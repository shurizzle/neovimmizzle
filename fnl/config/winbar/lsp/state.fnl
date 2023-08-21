(local State {:servers {}
              :changedtick 0
              :requesting false})

(fn State.new [self]
  (local o (setmetatable {:servers {}
                          :data nil
                          :changedtick 0
                          :requesting false}
                         self))
  (set self.__index self)
  o)

(fn State.get-server-by-id [self id]
  (some (fn [s] (when (= s.id id) s)) self.servers))

(fn State.get-server-by-name [self name]
  (some (fn [s] (when (= s.name name) s)) self.servers))

(fn State.remove-server-by-id [self id]
  (local i (some (fn [s i] (when (= s.id id) i)) self.servers))
  (when (not (nil? i))
    (values i (table.remove self.servers i))))

(fn State.remove-server-by-name [self name]
  (local i (some (fn [s i] (when (= s.name name) i)) self.servers))
  (when (not (nil? i))
    (values i (table.remove self.servers i))))

(fn State.add-server [self id name]
  (if (self:get-server-by-id id)
      false
      (do
        (table.insert self.servers {: id : name})
        true)))

(fn State.get-lsp-client [self]
  (var res nil)
  (while (and (not (empty? self.servers)) (not res))
    (local server (. self.servers 1))
    (local client (vim.lsp.get_client_by_id server.id))
    (if client
        (set res client)
        (table.remove self.servers 1)))
  res)

(fn State.set-data [self data]
  (if (vim.deep_equal self.data data)
      false
      (do
        (set self.data data)
        true)))

(var internal-states [])
(local u (require :config.winbar.util))

(fn get [bufnr] (. internal-states (u.ensure-bufnr bufnr)))

(fn get-or-create [?bufnr]
  (local bufnr (u.ensure-bufnr ?bufnr))
  (tset internal-states bufnr (or (. internal-states bufnr) (State:new)))
  (. internal-states bufnr))

(fn delete [bufnr]
  (tset internal-states (u.ensure-bufnr bufnr) nil))

{: get
 : get-or-create
 : delete}
