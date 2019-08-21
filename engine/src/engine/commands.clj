(ns engine.commands)

(defn add-command
  "Appends a new command to the list of commands."
  [g cmd]
  (let [action-id (-> g :actions count dec)
        cmd-with-action (assoc cmd :action-id action-id)]
    (update-in g [:commands] conj cmd-with-action)))

(defn add-obj
  [obj-id obj]
  {:new-object-id obj-id})

(defn remove-obj
  [obj-id]
  {:remove-object-id obj-id})

(defn move-obj
  [obj-id old-obj new-obj]
  {:move-object-id obj-id})

(defn set-moves
  ([obj-id old-obj obj] (set-moves obj-id obj))
  ([obj-id obj]
   {:set-moves obj-id :moves (obj :moves)}))

(defn set-active-player
  [p]
  {:set-active-player p})

(defn end-turn
  [p]
  {:end-turn p})
