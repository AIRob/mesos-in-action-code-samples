Rate limiting examples.

### ex01-rate-limit-jenkins.json
Rate limit only the `jenkins` framework. All other frameworks aren't throttled.

### ex02-rate-limit-chronos-and-unknown.json
Rate limit the `chronos` framework, but don't throttle the `marathon` framework.
Any undefined frameworks should be throttled according to the aggregate rate
limit and aggregate capacity.
