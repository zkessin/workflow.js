

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


test("Change State Events", () ->
    ok(false, "Test Not Yet Implemented"))
    
test("Change State Active Element", () ->
    ok(false, "Test Not Yet Implemented"))

test("Change State element is active", () ->
    ok(false, "Test Not Yet Implemented"))

test("Change State View Injected Activate Event Test", () ->
    ok(false, "Test Not Yet Implemented"))
    
test("Change State View Injected Deactivate Event Test", () ->
    ok(false, "Test Not Yet Implemented"))

test("Render Test", () ->
    ok(false, "Test Not Yet Implemented"))
