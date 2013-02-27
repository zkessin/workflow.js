

class Backbone.WorkflowArea extends Backbone.View
    setupStateTransitionEvent: () ->
        @model.on("transition:to", @changeState, @)
    initialize:  ({@views}) ->
        @setupStateTransitionEvent()
        @views ?= {}
        @state = @model.get('workflow_state')
        @createViews()
    createViews: () ->
        @states =  _.chain(@states)
            .filter(({component:component}) =>
                @views[component]?)
            .map( ({ state: state, component: component}) =>
                {
                    state     : state
                    component : component
                    view      : new @views[component]({model:@model})
                })
            .map((component) =>
                component.view.parent = @
                component)
            .value()
    changeState: () ->
        state    = @state
        oldView  = @getViewByName(state)
        newState = @model.get('workflow_state')
        @trigger("state_change")
        @trigger("state_change:#{@model.get('workflow_state')}")
        newView = @getViewByName(newState)
        oldView.trigger("deactivate")
        newView.trigger("activate")
        @state = newState
        @render()
        false
        
    getActiveState: () ->
        @model.get('workflow_state')
    getActiveView: () ->
        stateName = @getActiveState()
        @getViewByName(stateName)
    render: () ->
        activeView = @getActiveView()
        activeView.render()
        @$el.html(activeView.$el)
        @
    getViewByName: (name) ->
        _.findWhere(@states,{state: name})?.view
        
    isViewActive:(view) ->
        view is @getActiveView()