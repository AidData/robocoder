String::strip = -> if String::trim? then @trim() else @replace /^\s+|\s+$/g, ""

