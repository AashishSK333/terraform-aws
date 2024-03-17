variable filename1{
    type = string
    default = "variable1.txt"
}

variable content_num{
    type = number
    default = 33
}

variable content_bool{
    type = bool
    default = true
}

variable content_list{
    type = list(string)
    default = ["cap", "gap"]
}

variable content_tuple{
    type = tuple([string, bool, number])
    default = ["red", true, 33]
}

variable content_map{
    type = map
    default = {name = "Akhil", age = 33}
}