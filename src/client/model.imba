import 'gun/gun'

var INFORM_DEBOUNCE = 100 # ms

global class TodoModel

	prop items default: []
	
	def initialize key
		@listeners = []
		@key = key
		self

	def subscribe fn
		@listeners.push(fn)
		self
	
	def sorted
		items.sort do |a, b|
			let a = a:id.slice(1, 20) # time + random
			let b = b:id.slice(1, 20)
			return  1 if a < b # time desc
			return -1 if a > b
			return  0

	def inform
		clearTimeout(@timeout) if @timeout
		@timeout = setTimeout(&, INFORM_DEBOUNCE) do fn(self) for fn in @listeners
		self
		
	def put id, todo, cb
		return unless id
		var obj = todo ? {title: (todo:title or "<untitled>"), completed: (todo:completed or no)} : null
		@gun.path(id).put(obj, cb)
		self
		
	def uid
		'I' + Gun:time.now + 'R' + Gun:text.random 5

	def addTodo title
		put(uid(), {title: title, completed: no})

	def toggleAll state
		setCompleted(item, state) for item in items
		
	def setCompleted item, completed = yes
		put(item:id, {title: item:title, completed: completed})

	def toggle item
		put(item:id, {title: item:title, completed: !item:completed})

	def destroy item
		put(item:id, null)
		self

	def save item
		put(item:id, item)
		self

	def rename item, title
		put(item:id, {title: title, completed: item:completed})
		self

	def clearCompleted
		items.map do |item| destroy(item) if item:completed
		self

	def clearAll
		items.map do |item| destroy(item)
		self
	
	def load
		@gun = Gun(window:location:origin + '/gun').get(@key).not(do
			this.put({"{uid()}": {title: 'Digg it...😋😋😋😋😋😜😜😜😜😜',completed: no}}).key(@key)
		)
		@gun.map do |item, id|
			# console.log item, id
			return unless id
			var todo = i for i in @items when(i:id == id)
			if todo and item is null # removed item
				@items.splice(@items.indexOf(todo), 1)
				inform
			elif todo # updated item
				if todo != item
					todo:title = item:title or "<untitled>"
					todo:completed = item:completed or no
					inform
			elif item and not todo # new item
				@items.push({id: id, title: item:title, completed: (item:completed or no)})
				inform
		self
