(local {: round : rgb : rgb->hex} (require :config.colors.blush.color.common))

(fn hue->rgb [p q t*]
  (let [t (if (< t* 0) (+ t* 1)
              (> t* 1) (- t* 1)
              t*)]
    (if (< t (/ 1 6)) (+ p (* (- q p) 6 t))
        (< t (/ 1 2)) q
        (< t (/ 2 3)) (+ p (* (- q p) (- (/ 2 3) t) 6))
        p)))

(fn ->rgb [{: h : s : l}]
  (fn rgb* [r g b]
    (rgb (round (* r 255)) (round (* g 255)) (round (* b 255))))

  (if (= 0 s)
      (rgb* l l l)
      (let [q (if (< l 0.5)
                  (* l (+ 1 s))
                  (+ l (- s (* l s))))
            p (- (* 2 l) q)]
        (rgb* (hue->rgb p q (+ h (/ 1 3))) (hue->rgb p q h)
              (hue->rgb p q (- h (/ 1 3)))))))

(fn ->hex [hsl]
  (-?> (->rgb hsl)
       (rgb->hex)))

(fn hslf [h s l]
  (setmetatable {: h : s : l} {:__tostring ->hex}))

(fn hsl [h s l]
  (hslf (/ h 360) (/ s 100) (/ l 100)))

(fn inv [value]
  (when (not= :number (type value))
    (error "Must provide number to HSL modifers" 0))
  (- value))

(fn abs-f [hsl key value]
  (when (not= :number (type value))
    (error "Must provide number to HSL modifers" 0))
  (let [new {:h hsl.h :s hsl.s :l hsl.l}]
    (tset new key (+ (. new key) value))
    (hslf new.h new.s new.l)))

(fn abs [hsl key value divisor]
  (when (not= :number (type value))
    (error "Must provide number to HSL modifers" 0))
  (abs-f hsl key (/ value divisor)))

(fn inv-abs-f [hsl key value]
  (abs-f hsl key (inv value)))

(fn inv-abs [hsl key value divisor]
  (when (not= :number (type value))
    (error "Must provide number to HSL modifers" 0))
  (inv-abs-f hsl key (/ value divisor)))

(fn lerp [hsl key percent]
  (when (not= :number (type percent))
    (error "Must provide number to HSL modifiers" 0))
  (let [new {:h hsl.h :s hsl.s :l hsl.l}
        percent (/ percent 100)
        value (. new key)
        lerp-space (if (< percent 0) value (- 1.0 value))]
    (tset new key (+ value (* lerp-space percent)))
    (hslf new.h new.s new.l)))

(fn inv-lerp [hsl key percent]
  (lerp hsl key (inv percent)))

(fn rotate [hsl value]
  (abs hsl :h value 360))

(fn rotate-f [hsl value]
  (abs-f hsl :h value))

(fn saturate [hsl percent]
  (lerp hsl :s percent))

(fn abs-saturate [hsl value]
  (abs hsl :s value 100))

(fn abs-f-saturate [hsl value]
  (abs-f hsl :s value))

(fn desaturate [hsl percent]
  (inv-lerp hsl :s percent))

(fn abs-desaturate [hsl value]
  (inv-abs hsl :s value 100))

(fn abs-f-desaturate [hsl value]
  (inv-abs-f hsl :s value))

(fn lighten [hsl percent]
  (lerp hsl :l percent))

(fn abs-lighten [hsl value]
  (abs hsl :l value 100))

(fn abs-f-lighten [hsl value]
  (abs-f hsl :l value))

(fn darken [hsl percent]
  (inv-lerp hsl :l percent))

(fn abs-darken [hsl value]
  (inv-abs hsl :l value 100))

(fn abs-f-darken [hsl value]
  (inv-abs-f hsl :l value))

(setmetatable {: ->rgb
               : ->hex
               :float hslf
               : rotate
               : rotate-f
               : saturate
               : abs-saturate
               : abs-f-saturate
               : desaturate
               : abs-desaturate
               : abs-f-desaturate
               : lighten
               : abs-lighten
               : abs-f-lighten
               : darken
               : abs-darken
               : abs-f-darken} {:__call hsl})
