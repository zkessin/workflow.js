// Generated by CoffeeScript 1.5.0
(function() {
  var LoginArea, User, makeViews,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  User = (function(_super) {

    __extends(User, _super);

    function User() {
      User.__super__.constructor.apply(this, arguments);
    }

    User.prototype.workflow = {
      initial: 'guest',
      events: [
        {
          name: 'login',
          from: 'guest',
          to: 'user'
        }, {
          name: 'logout',
          from: 'user',
          to: 'guest'
        }
      ]
    };

    User.prototype.initialize = function() {
      return _.extend(this, new Backbone.Workflow(this));
    };

    return User;

  })(Backbone.Model);

  LoginArea = (function(_super) {

    __extends(LoginArea, _super);

    function LoginArea() {
      LoginArea.__super__.constructor.apply(this, arguments);
    }

    LoginArea.prototype.states = [
      {
        state: "guest",
        component: "login"
      }, {
        state: "user",
        component: "logout"
      }
    ];

    return LoginArea;

  })(Backbone.WorkflowArea);

  makeViews = function(Base) {
    var views;
    return views = {
      login: Base,
      logout: Base
    };
  };

  module("Workflow Area", {
    setup: function() {
      return false;
    }
  });

  test("Setup View Test ", function() {
    var la, user;
    user = new User();
    la = new LoginArea({
      model: user
    });
    deepEqual(la.model, user, "Test that we have the correct model");
    return equal("guest", la.getActiveState(), "Test that we have the correct state");
  });

  test("Event Binding Test ", function() {
    var la, user;
    user = new User();
    expect(5);
    user.on = function(event, callback, context) {
      equal("transition:to", event, "Test the event name");
      ok(_.isFunction(callback), "Test the event callback");
      return ok(_.isObject(context), "Test that we have a context object");
    };
    la = new LoginArea({
      model: user
    });
    deepEqual(la.model, user, "Test that we have the correct model");
    return equal("guest", la.getActiveState(), "Test that we have the correct state");
  });

  test("Create Views Test", function() {
    var TestView, la, twice, user, views;
    expect(1);
    twice = _.after(2, function() {
      start();
      return ok(true, "Test that Initalize has been called twice");
    });
    TestView = Backbone.View.extend({
      initialize: function() {
        return twice();
      }
    });
    views = makeViews(TestView);
    user = new User();
    stop();
    return la = new LoginArea({
      model: user,
      views: views
    });
  });

  test("Change State Test", function() {
    var la, user, views,
      _this = this;
    views = makeViews(Backbone.View);
    user = new User();
    expect(2);
    la = new LoginArea({
      model: user,
      views: views
    });
    la.on('state_change', function() {
      return equal(la.model.get('workflow_state'), 'user', "Test that the state change method is called");
    });
    la.on('state_change:user', function() {
      return equal(la.model.get('workflow_state'), 'user', "Test that the state change method is called");
    });
    return user.triggerEvent('login');
  });

  test("getViewByNameTest", function() {
    var la, user, view, views;
    views = makeViews(Backbone.View);
    user = new User();
    la = new LoginArea({
      model: user,
      views: views
    });
    view = la.getViewByName('guest');
    return ok(_.isObject(view), "Test the view");
  });

  test("Get Parent from view", function() {
    var la, user, view, views;
    views = makeViews(Backbone.View);
    user = new User();
    la = new LoginArea({
      model: user,
      views: views
    });
    view = la.getViewByName('guest');
    ok(_.isObject(view), "Test the view");
    ok(_.isObject(view.parent), "Test that view.parent is defined");
    return deepEqual(view.parent, la, "Test taht view.parent is la");
  });

  test("Change State View Injected Activate Event Test", function() {
    var la, user, view, views;
    views = makeViews(Backbone.View);
    user = new User();
    la = new LoginArea({
      model: user,
      views: views
    });
    view = la.getViewByName('user');
    expect(1);
    view.bind("activate", function() {
      return ok(true, "Got the activate event");
    });
    return user.triggerEvent('login');
  });

  test("Change State Active Element", function() {
    return ok(false, "Test Not Yet Implemented");
  });

  test("Change State element is active", function() {
    return ok(false, "Test Not Yet Implemented");
  });

  test("Change State View Injected Deactivate Event Test", function() {
    return ok(false, "Test Not Yet Implemented");
  });

  test("Render Test", function() {
    return ok(false, "Test Not Yet Implemented");
  });

}).call(this);
