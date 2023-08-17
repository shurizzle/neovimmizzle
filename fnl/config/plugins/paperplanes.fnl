{:lazy true
 :cmd :PP
 :config (fn [] ((. (require :paperplanes) :setup) {:register :+
                                                    :provider :paste.rs}))}
