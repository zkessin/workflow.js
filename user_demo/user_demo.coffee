

class User extends Backbone.Model
  workflow:
    initial: 'guest'
    events: [
      { name: 'login',  from: 'guest', to: 'user' }
      { name: 'logout', from: 'user',  to: 'guest' }
    ]

  initialize: ->
    _.extend @, new Backbone.Workflow(@)


UserView = Backbone.View.extend
    templates: {
        guest: {
            selector: "#login"
            tpl: _.template("<button class='loginbtn'>Login</button>")
        }
        user:{
            selector: "#user_info"
            tpl: _.template("<button class='logoutbtn'>Hello User</button>")
        }}
    states:
        "user": "show"
        "guest": "hide"
    initialize: ->
        @model.bind('transition:to', () => @render())
#        @model.bind('transition:from:guest', () -> @hide())
#        @model.bind('transition:to:guest',   () -> @show())
    render: () ->
        {
            tpl: template,
            selector: selector
        } = @templates[@model.get('workflow_state')]
        $new       = $(template(@model.toJSON()))
        @$el.remove()
        $(selector).html($new)
        @setElement($new)
        @



$(() ->
    user    = new User()
    userView = new UserView({model: user})
    userView.render()
  
    $(".loginbtn").live("click", () ->
        user.triggerEvent("login"))
    $(".logoutbtn").live("click", () ->
        user.triggerEvent("logout")))
