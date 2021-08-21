# Assembly-Exercises
Mini projects of Assembly language

1. ex1: Find all prime numbers (such as 2, 3, 5, 7, ...)  in a range from the integer N to the integer M.
2. ex2: Define a word as a sequence of consecutive English letters. Find the longest word from the given string.
   - Example For text = "Ready, steady, go!", the output should be "steady".
3. ex3: Create a program to: 
    - Input an array of integer from keyboard.
    - Find the maximum element of array.
    - Calculate the number of elements in the range of (m, M). Range m, M are integer numbers entered from keyboard.
4. mini project: Chương trình kiểm tra cú pháp lệnh MIPS.
    - Trình biên dịch của bộ xử lý MIPS sẽ tiến hành kiểm tra cú pháp các lệnh hợp ngữ trong mã nguồn, xem có phù hợp về cú pháp hay không, rồi mới tiến hành dịch các lệnh ra mã máy. Hãy viết một chương trình kiểm tra cú pháp của 1 lệnh hợp ngữ MIPS bất kì (không làm với giả lệnh) như sau: 
    + Nhập vào từ bàn phím một dòng lệnh hợp ngữ. Ví dụ: beq $s1, $31, $t4 
    + Kiểm tra xem mã opcode có đúng hay không? Trong ví dụ trên, opcode là beq là hợp lệ thì hiển thị thông báo “opcode: beq, hợp lệ”
    + Kiểm tra xem tên các toán hạng phía sau có hợp lệ hay không? Trong ví dụ trên, toán hạng s1 là hợp lệ, 31 là không hợp lệ, t4 thì khỏi phải kiểm tra nữa vì toán hạng trước đã bị sai rồi.
    - Gợi ý: nên xây dựng một cấu trúc chứa khuôn dạng của từng lệnh với tên lệnh, kiểu của toán hạng 1, toán hạng 2, toán hạng 3.
  
