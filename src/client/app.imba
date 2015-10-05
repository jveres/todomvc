import 'imba'
import 'index.css'
import 'model'
import ENTER_KEY, ITEM_HEIGHT from 'item'

Todos = TodoModel.new "todo/data"

# RAF helper
var raf = window:requestAnimationFrame || setTimeout
var next-tick = (|fn| raf(do raf fn) if fn)

extend tag htmlelement

	var bounces = ["up", "down"]
	
	# using pure CSS animations makes it performant even on an old N7
	def bounce a
		var b = bounces[1 - bounces.indexOf(a)]
		["bounce-{b}-1", "bounce-{b}-2"].map(|f| unflag f)
		# this way we can play the same CSS animation repeatedly *uhm*
		if hasFlag "bounce-{a}-1"
			unflag "bounce-{a}-1"
			flag "bounce-{a}-2"
		elif hasFlag "bounce-{a}-2"
			unflag "bounce-{a}-2"
			flag "bounce-{a}-1"
		else
			flag "bounce-{a}-1"
		self
		
	# attribute for animated positioning
	def move-to= y
		next-tick do dom:style:opacity = 1 if dom:style:opacity == 0 # fadein
		return self if dom:style:top == "{y}px" # simple debounce rule
		# TODO: apply animation only when the visible viewport contains the element
		bounce "up" if ~~y < ~~@y # moving up
		bounce "down" if not @y or ~~y > ~~@y # newly inserted or moving down
		@dom:style:top = "{y}px" # set position
		@y = y # 
		return self
		
tag app

	def hash
		@hash

	def model
		@model

	def build
		@model = Todos
		@model.subscribe do render
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
			model.addTodo(value)
			e.target.value = ""

	def toggleAll e
		model.toggleAll e.target.checked
		
	def clearCompleted
		%%(.toggle-all).checked = no
		model.clearCompleted

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
				<input.new-todo type='text' placeholder='What to do?'>

			if len
				<section.main>
					<input.toggle-all type='checkbox' checked=(done:length == len) :change='toggleAll'>
					<ul.todo-list>
						list(items)

			if len
				<footer.footer move-to="{items:length * ITEM_HEIGHT}">
					<span.todo-count>
						<strong> "{active:length} "
						active:length == 1 ? "item left" : "items left"
					<ul.filters>
						<li> <a .selected=(items == all) href='#/'> "All"
						<li> <a .selected=(items == active) href='#/active'> "Active"
						<li> <a .selected=(items == done) href='#/completed'> "Completed"
					if done:length
						<button.clear-completed :tap='clearCompleted'> "Clear completed"

# create an instance of the app (with id app)
var app = <app#app>

# append it to the dom
$$(body).append app
