package main
import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {

	file, err := os.open("res/input.txt")

	if err != os.ERROR_NONE {
		fmt.printfln("Error openin file: ", err)
		return
	}

	defer os.close(file)

	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Error reading file")
		return
	}

	defer delete(data, context.allocator)
	content := string(data)

	// filter line by line and add left to left list and right to right list
	left_list : [dynamic]int
	right_list : [dynamic]int

	for line in strings.split_lines_iterator(&content) {
		// process line
    left,right := get_numbers(line)
		append (&left_list,left)
		append (&right_list,right)
	}

  slice.sort(left_list[:])
  slice.sort(right_list[:])
  fmt.println(left_list[0])
  fmt.println(right_list[0])
  

  // FIRST PART 
  result := 0
  for i in 0..<len(left_list) {
   if left_list[i] < right_list[i]{
     result = result +  (right_list[i] -  left_list[i])  
   } else {
     result = result +  (left_list[i] - right_list[i])
   }

  }
  fmt.println(result)
  
  // Second PART 
  
  total := 0;
  for i in 0..<len(left_list){
    // I have a left_list number  how many times it appears in right_list 
    n:= 0
    for j in 0..<len(right_list){
      if left_list[i] == right_list[j]{
        n += 1
      }
    }
    total += left_list[i] * n
  }

    fmt.println(total)

}

get_numbers::proc(line : string) -> (left: int,right: int) {
		numbers := strings.split(line," ")
	  
    // PARSE 
    left_num, ok := strconv.parse_int(numbers[0])
		if !ok  {
			fmt.println("Error converting string to integer 0 :")
			return
		}

		right_num, ok_right := strconv.parse_int(numbers[3])
		if !ok_right  {
			fmt.println("Error converting string to integer 1 :")
			return
		}

    return left_num,right_num
}
