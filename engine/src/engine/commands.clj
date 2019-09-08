(ns engine.commands)

(defn add-command
  "Appends a new command to the list of commands."
  [g cmd]
  (let [action-id (-> g :actions count dec)
        cmd-with-action (assoc cmd :action-id action-id)]
    (update-in g [:commands] conj cmd-with-action)))

(defn add-obj
  [obj-id obj]
  {:command :add-object :object-id obj-id})

(defn remove-obj
  [obj-id]
  {:command :remove-object :object-id obj-id})

(defn destroy-obj
  [obj-id]
  {:command :destroy-object :object-id obj-id})

(defn move-obj
  [obj-id old-obj new-obj]
  {:command :move-object :object-id obj-id})

(defn set-moves
  ([obj-id old-obj obj] (set-moves obj-id obj))
  ([obj-id obj]
   {:command :set-moves :object-id obj-id :moves (obj :moves)}))

(defn set-active-player
  [p]
  {:command :set-active-player :player p})

(defn end-turn
  [p]
  {:command :end-turn :player p})

(defn set-health
  ([obj-id old-obj obj] (set-health obj-id obj))
  ([obj-id obj]
   {:command :set-health :object-id obj-id :health (obj :health)}))

(defn attack
  [obj-id target-id damage]
  {:command :attack :attacker obj-id :target target-id :damage damage})

(defn player-lost
  [p]
  {:command :player-lost :player p})

(defn player-won
  [p]
  {:command :player-won :player p})

(defn game-over
  []
  {:command :game-over})