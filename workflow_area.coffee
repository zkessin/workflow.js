

class Backbone.WorkflowArea extends Backbone.View
    setupStateTransitionEvent: () ->
        @model.on("transition:to", @changeState, @)
    initialize:  () ->
        @setupStateTransitionEvent()
    changeState: () ->
        false
    getActiveState: () ->
        @model.get('workflow_state')