import 'imba'
import 'index.css'
import 'app.css'
import 'model'
import play from 'anima'
import ENTER_KEY, ITEM_HEIGHT from 'item'

Todos = TodoModel.new "todo/data"

# RAF helper
var raf = window:requestAnimationFrame || setTimeout
var next-tick = (|fn| raf(do raf fn) if fn)

var MAX-PERISCOPE-HEARTS = 10
var periscope-hearts = 0

extend tag htmlelement
	
	# using pure CSS animations makes it performant even on an old N7
	def bounce dir
		if not @bounce or @bounce == "bounce-{dir}-2"
			@bounce = "bounce-{dir}-1"
		else
			@bounce = "bounce-{dir}-2"
		play @dom, @bounce
		self
		
	# attribute for animated positioning
	def move-to= y
		next-tick do @dom:style:opacity = 1 if @dom:style:opacity == 0 # fadein
		return self if @dom:style:top == "{y}px" # simple debounce rule
		# TODO: apply animation only when the visible viewport contains the element
		bounce "up" if ~~y < ~~@y # moving up
		bounce "down" if not @y or ~~y > ~~@y # newly inserted or moving down
		@dom:style:top = "{y}px" # set position
		@y = y # save position
		return self
		
tag heart < div

	var hearts = ["\uD83D\uDC9C", "\uD83D\uDC9A", "\uD83D\uDC9B", "\uD83D\uDC99"] # these are HTML hearts with different color
	
	def render
		<self.heart> "{@heart}"
	
	def build
		@heart = hearts[Math.floor(Math.random * hearts:length)] # random heart
		@fly = "fly-{Math.floor(Math.random * 3) + 1}" # random fly animation
		@dom:style:font-size = Math.floor(Math.random * 6) + 15 + "px" # random size
		play @dom, @fly, do
			# TODO: recycle instead of orphanize
			orphanize # remove from dom
			periscope-hearts--
		periscope-hearts++
		render
		self
	
tag app

	def hash
		@hash

	def model
		@model

	def build
		@model = Todos
		@model.subscribe(do
			$$(#heartbox).append(<heart>) if periscope-hearts < MAX-PERISCOPE-HEARTS # show periscope heart
			render # re-render app
		)
		@model.load
		window.addEventListener "hashchange" do
			@hash = window:location:hash
			render
		@hash = window:location:hash
		render
		self

	def onkeydown e
		return unless e.which == ENTER_KEY
		if var value = e.target.value.trim
			model.add-todo(value)
			e.target.value = ""

	def toggleAll e
		model.toggle-all e.target.checked
		
	def clearCompleted
		%%(.toggle-all).checked = no
		model.clear-completed

	def list items
		for item, index in items
			<todo[item]@{item:id} move-to="{index * ITEM_HEIGHT}">

	def render
		var all = Todos.sorted # newest first
		var len = all:length
		var done = []
		var active = []
		for todo in all
			todo:completed ? done.push(todo) : active.push(todo)
			
		var items  = {"#/completed": done, "#/active": active}[@hash] or all
		
		<self>
			<header.header>
				<h1> "todos"
				<p#heartbox>
				<input.new-todo type='text' placeholder='What to do?'>

			if len > 0
				<section.main>
					<input.toggle-all type='checkbox' checked=(done:length == len) :change='toggleAll'>
					<ul.todo-list>
						list(items)
			
			if len > 0
				<footer.footer move-to="{items:length * ITEM_HEIGHT}">
					<span.todo-count>
						<strong> "{active:length} "
						active:length == 1 ? "item left" : "items left"
					<ul.filters>
						<li> <a .selected=(items == all) href='#/'> "All"
						<li> <a .selected=(items == active) href='#/active'> "Active"
						<li> <a .selected=(items == done) href='#/completed'> "Completed"
					if done:length > 0
						<button.clear-completed :tap='clearCompleted'> "Clear completed"

# create an instance of the app (with id app)
var app = <app#app>

# append it to the dom
$$(body).append app
