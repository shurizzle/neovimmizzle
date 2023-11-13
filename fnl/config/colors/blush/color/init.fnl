(local {: rgb->hex : rgb} (require :config.colors.blush.color.common))
(local hsl (require :config.colors.blush.color.hsl))
(local {:->hex name->hex :beauty name-beauty}
       (require :config.colors.blush.color.names))

(fn hex->rgb [hex]
  (fn parse [c hex post?]
    (let [post (or post? #$1)
          pat (.. "^(" c ")(" c ")(" c ")$")
          (r g b) (string.match (string.lower hex) pat)]
      (when (and r g b)
        (rgb (tonumber (post r) 16)
             (tonumber (post g) 16)
             (tonumber (post b) 16)))))

  (let [hex (if (= :# (hex:sub 1 1))
                 (hex:sub 2)
                 hex)]
    (match (length hex)
      (where 3) (parse "[a-f0-9]" hex #(.. $1 $1))
      (where 6) (parse "[a-f0-9][a-f0-9]" hex))))

(fn rgb->hsl [rgb]
  (let [r (/ rgb.r 255)
        g (/ rgb.g 255)
        b (/ rgb.b 255)
        max (math.max r g b)
        min (math.min r g b)
        l (/ (+ max min) 2)]
    (if (= max min)
        (hsl.float 0 0 l)
        (let [d (- max min)
              s (if (> l 0.5) (/ d (- 2 max min)) (/ d (+ max min)))
              h* (if
                   (= max r) (let [h (/ d (- g b))]
                               (if (< g b) (+ h 6) h))
                   (= max g) (+ (/ (- b r) d) 2)
                   (= max b) (+ (/ (- r g) d) 4))
              h (/ h* 6)]
          (hsl.float h s l)))))

(fn hex->hsl [hex]
  (-?> (hex->rgb hex)
       (rgb->hsl)))

(fn name->rgb [name]
  (-?> name
       (name->hex)
       (hex->rgb)))

(fn name->hsl [name]
  (-?> name
       (name->hex)
       (hex->hsl)))

{: rgb
 : rgb->hex
 : hex->rgb
 : hsl
 : rgb->hsl
 : hex->hsl
 :hsl->hex hsl.->hex
 :hsl->rgb hsl.->rgb
 : name->hex
 : name->rgb
 : name->hsl
 : name-beauty}
