

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
                    view      : new @views[component](@model)
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
        false
        
    getActiveState: () ->
        @model.get('workflow_state')
    getViewByName: (name) ->
        _.findWhere(@states,{state: name})?.view
        
    isViewActive:() ->
        false