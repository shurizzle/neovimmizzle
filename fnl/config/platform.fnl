(macro match-os [& args]
  (assert-compile (= 0 (% (length args) 2)) "Invalid match-os syntax" args)
  `(let [os# (. (vim.loop.os_uname) :sysname)]
     ,(let [exprs `(if)]
        (for [i (length args) 2 -2]
          (table.insert exprs `(: os# :match ,(. args (- i 1))))
          (table.insert exprs (. args i)))
        (table.insert exprs :unknown)
        exprs)))

(local os (match-os
            :Windows   :windows
            :Linux     :linux
            :Darwin    :macos
            :FreeBSD   :freebsd
            :DragonFly :dragonflybsd
            :NetBSD    :netbsd
            :OpenBSD   :openbsd))

(fn extract [env]
  (-?>> (-?> env (: :find "%s") (- 1)) (: env :sub 0)))

(fn coalesce-map [map & rest]
  (each [_ name (ipairs rest)]
    (let [res (map name)]
      (if res (lua "return res")))))

(local ssh-remote (coalesce-map #(extract (. vim.env $1)) :SSH_CLIENT :SSH_CONNECTION))

(var _is {:win      (= os :windows)
          :lin      (= os :linux)
          :mac      (= os :macos)
          :fbsd     (= os :freebsd)
          :dfbsd    (= os :dragonflybsd)
          :nbsd     (= os :netbsd)
          :obsd     (= os :openbsd)
          :ssh      (not= nil ssh-remote)
          :headless (vim.tbl_isempty (vim.api.nvim_list_uis))
          :termux   (not= nil vim.env.TERMUX_APP_PID)
          :unknown  (= os :unknown)})

(each [k v (pairs {:windows      :win
                   :linux        :lin
                   :macos        :mac
                   :freebsd      :fbsd
                   :dragonflybsd :dfbsd
                   :netbsd       :nbsd
                   :openbsd      :obsd})]
  (tset _is k (. _is v)))

(tset _is :bsd (or _is.mac _is.fbsd _is.dfbsd _is.nbsd _is.obsd))

(readonly-table {:os os :is (readonly-table _is) :ssh ssh-remote})
