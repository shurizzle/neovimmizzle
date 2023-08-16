(let [lush (require :lush)]
  (lush (fn []
          [(IlluminatedWordText {:gui :underline})
           (illuminateWordRead [IlluminatedWordText])
           (illuminateWordWrite [IlluminatedWordText])])))
