(fn [cb]
  (tset (require :conform) :formatters :muon
        {:meta {:url "https://muon.build/"
                :description "An implementation of the meson build system in c99"}
         :command :muon
         :args [:fmt "-"]
         :stdin true})
  (cb :muon))
