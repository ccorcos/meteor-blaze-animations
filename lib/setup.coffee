@_ = _.extend lodash, _

@delay = (ms, func) -> Meteor.setTimeout func, ms