local Future = {}
Future.__index = Future

local function instanceof(subject, super)
  super = tostring(super)
  local mt = getmetatable(subject)

  while true do
    if mt == nil then
      return false
    end
    if tostring(mt) == super then
      return true
    end

    mt = getmetatable(mt)
  end
end

function Future.new(cb)
  vim.validate({
    cb = { cb, 'function' },
  })

  local o = {
    resolved = nil,
    state = {},
    callbacks = {
      ok = {},
      ko = {},
    },
  }
  setmetatable(o, Future)

  local function run(resolved, state, callbacks)
    o.resolved = resolved
    o.state = state
    o.callbacks = nil
    for _, fn in ipairs(callbacks) do
      vim.schedule(function()
        fn(o.state)
      end)
    end
  end

  local ok, err = pcall(cb, function(res)
    run(true, res, o.callbacks.ok)
  end, function(err)
    run(false, err, o.callbacks.ko)
  end)

  if not ok then
    run(false, err, o.callbacks.ko)
  end

  return o
end

function Future.resolved(state)
  local o = {
    resolved = true,
    state = state,
  }
  setmetatable(o, Future)

  return o
end

function Future.rejected(state)
  local o = {
    resolved = false,
    state = state,
  }
  setmetatable(o, Future)

  return o
end

function Future.pcall(fn, ...)
  local ok, res = pcall(fn, ...)

  if ok then
    if instanceof(res, Future) then
      return res
    else
      return Future.resolved(res)
    end
  else
    return Future.rejected(res)
  end
end

function Future.wrap(val)
  if instanceof(val, Future) then
    return val
  else
    return Future.resolved(val)
  end
end

function Future:and_then(cb, catchCb)
  vim.validate({
    cb = { cb, 'function', true },
    catchCb = { catchCb, 'function', true },
  })

  if not cb and not catchCb then
    return self
  end

  if type(self.resolved) == 'boolean' then
    if self.resolved then
      if cb then
        return Future.pcall(cb, self.state)
      else
        return self
      end
    else
      if catchCb then
        return Future.pcall(catchCb, self.state)
      else
        return self
      end
    end
  else
    return Future.new(function(resolve, reject)
      table.insert(self.callbacks.ok, function(res)
        if cb then
          Future.pcall(cb, res):and_then(resolve, reject)
        else
          resolve(res)
        end
      end)

      table.insert(self.callbacks.ko, function(res)
        if catchCb then
          Future.pcall(catchCb, res):and_then(resolve, reject)
        else
          resolve(res)
        end
      end)
    end)
  end
end

function Future:catch(cb)
  return self:and_then(nil, cb)
end

function Future:finally(cb)
  vim.validate({
    cb = { cb, 'function', true },
  })

  if cb then
    return self:and_then(function(res)
      cb(true, res)
    end, function(err)
      cb(false, err)
    end)
  else
    return self
  end
end

function Future.join(futures)
  vim.validate({
    futures = { futures, 'table' },
  })

  local len = vim.tbl_count(futures)

  if len == 0 then
    return Future.resolved({})
  end

  local results = {}
  local resolve
  local joined = Future.new(function(a)
    resolve = a
  end)
  for index, value in pairs(futures) do
    futures[index]:finally((function(i)
      return function(ok, res)
        results[i] = { ok, res }
        if vim.tbl_count(results) == len then
          resolve(results)
        end
      end
    end)(index))
  end

  return joined
end

return Future
