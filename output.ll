; ModuleID = 'calc_module'
source_filename = "calc_module"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

define i32 @main() {
entry:
  %0 = call i32 (ptr, ...) @printf(ptr @fmt, i32 11)
  ret i32 0
}

declare i32 @printf(ptr, ...)
