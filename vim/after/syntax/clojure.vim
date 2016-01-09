" highlight other def forms I use often
let defineForms = ["defsfn", "s/def", "s/defn", "defmultischema", "s/defmethod","defschema","defresource", "s/defschema", "s/defaction"]
execute 'syntax keyword clojureDefine' join(defineForms, ' ')
