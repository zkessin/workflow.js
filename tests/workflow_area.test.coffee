

class User extends Backbone.Model
  workflow:
    initial: 'guest'
    events: [
      { name: 'login',  from: 'guest', to: 'user' }
      { name: 'logout', from: 'user',  to: 'guest' }
    ]

  initialize: ->
    _.extend @, new Backbone.Workflow(@)


    
class LoginArea extends Backbone.WorkflowArea
    states:[
        {
            state: "guest"
            component: "login"
        },
        {
            state: "user"
            component: "logout"
        }]

makeViews = (Base) ->
    views = {
        login:   Base
        logout:  Base
        }
        
#----------------------------------------------------------------------    
module "Workflow Area",
    setup: ->
        false


test("Setup View Test ", ->
    user = new User()
    la   = new LoginArea({model: user})
    deepEqual(la.model, user,           "Test that we have the correct model")
    equal("guest", la.getActiveState(), "Test that we have the correct state")    
    )

test("Event Binding Test ", ->
    user = new User()
    expect 5
    user.on = (event, callback, context) ->
        equal("transition:to", event,   "Test the event name")
        ok(_.isFunction(callback),      "Test the event callback")

        ok(_.isObject(context),         "Test that we have a context object")

    la   = new LoginArea({model: user})
    deepEqual(la.model, user,           "Test that we have the correct model")
    equal("guest", la.getActiveState(), "Test that we have the correct state")    
    ) 



test("Create Views Test", ->
    expect 1
    twice = _.after(2, () ->
        start()
        ok(true, "Test that Initalize has been called twice")
        )

    TestView = Backbone.View.extend(
        initialize: ->
            twice()
        )    
    views = makeViews(TestView)
    user = new User()
    stop()
    la   = new LoginArea({
        model: user
        views: views})
    
    )

    
test("Change State Test", () ->
    views = makeViews(Backbone.View)
    user = new User()
    expect(2)
    la   = new LoginArea({
        model: user
        views: views})
    la.on('state_change',() =>
        equal(la.model.get('workflow_state'), 'user', "Test that the state change method is called"))
    la.on('state_change:user',() =>
        equal(la.model.get('workflow_state'), 'user', "Test that the state change method is called"))
    user.triggerEvent('login')
    
    )

test("getViewByNameTest", () ->
    views = makeViews(Backbone.View)
    user = new User()
    
    la   = new LoginArea({
        model: user
        views: views})

    view = la.getViewByName('guest')

    ok(_.isObject(view), "Test the view"))

test("Get Parent from view", () ->
    views = makeViews(Backbone.View)
    user = new User()
    
    la   = new LoginArea({
        model: user
        views: views})

    view = la.getViewByName('guest')
    ok(_.isObject(view), "Test the view")
    ok(_.isObject(view.parent), "Test that view.parent is defined")
    deepEqual(view.parent, la, "Test taht view.parent is la"))

    
    

test("Change State View Injected Activate Event Test", () ->
    views = makeViews(Backbone.View)
    user = new User()
    la   = new LoginArea({
        model: user
        views: views})
    view = la.getViewByName('user')
    expect 1
    view.bind("activate", () ->
        ok(true, "Got the activate event"))
  
    user.triggerEvent('login'))
    
test("Change State View Injected Activate Event Test", () ->
    views = makeViews(Backbone.View)
    user = new User()
    la   = new LoginArea({
        model: user
        views: views})
    view = la.getViewByName('guest')
    expect 1
    view.bind("deactivate", () ->
        ok(true, "Got the activate event"))
  
    user.triggerEvent('login'))
 

test("Change State Active Element", () ->
    views = makeViews(Backbone.View)
    user = new User()
    la   = new LoginArea({
        model: user
        views: views})
    view = la.getViewByName('guest')
    
    activeView1 = la.getActiveView()
    ok(activeView1 instanceof Backbone.View, "Test that we have a view")
    user.triggerEvent('login')
    activeView2 = la.getActiveView()
    ok(activeView2 instanceof Backbone.View, "Test that we have a view")
    notEqual(activeView2, activeView1, "Test that the objects are not the same")
    )

test("Change State element is active", () ->
    views = makeViews(Backbone.View)
    user = new User()
    la   = new LoginArea({
        model: user
        views: views})
    view = la.getViewByName('guest')
    
    activeView1 = la.getActiveView()
    ok(activeView1 instanceof Backbone.View, "Test that we have a view")

    user.triggerEvent('login')
    
    activeView2 = la.getActiveView()
    ok(activeView2 instanceof Backbone.View, "Test that we have a view")
    notEqual(activeView2, activeView1, "Test that the objects are not the same")
    ok(la.isViewActive(activeView2), "Test that the view is active")
    ok(!la.isViewActive(activeView1), "Test that the view is not active")
    )
    

test("Render Test", () ->
    TestView = Backbone.View.extend({
        render: () ->
            ok(true)
        })
    expect(2)
    views = makeViews(TestView)
    user = new User()
    la   = new LoginArea({
        model: user
        views: views})
    activeView = la.getActiveView()
    la.render()
    user.triggerEvent('login')
    )
