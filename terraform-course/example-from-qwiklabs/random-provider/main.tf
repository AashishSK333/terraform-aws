resource random_integer name {
  min = 80
  max = 200
}


output name1 {
  value       = random_integer.name.result
}
