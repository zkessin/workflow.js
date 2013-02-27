

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


        