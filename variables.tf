variable "mongdbatlas_project_id" {
    type = string
    default = "61e9c520e14c830d623e1c42"
}

variable "koodoo_json" {
    type = string
    default = "koodoo.json"
}

variable "service_configuration" {
    type = list(string)
    default = ["aws_private_link","aws_private_link_srv","private","private_endpoint","private_srv","standard", "standard_srv" ]
}

variable "environment" {
    type = string
    default = ""
}

variable "password_length" {
    type = number
    default = 16
}

variable "password_special_chars" {
    type = string
    default = "!#$%&*()-_=+[]{}<>?"
}
