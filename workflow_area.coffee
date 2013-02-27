

class Backbone.WorkflowArea extends Backbone.View
    setupStateTransitionEvent: () ->
        @model.on("transition:to", @changeState, @)
    initialize:  ({@views}) ->
        @setupStateTransitionEvent()
        @views ?= {}
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
                }).value()
    changeState: () ->
        false
    getActiveState: () ->
        @model.get('workflow_state')
