
# Verilog MIPS 测评机

一个基于 Python 的简单 Verilog 测评工具，用于 MIPS 处理器的功能验证。

## 功能特性

- 自动生成可靠的 MIPS 汇编代码
- 支持汇编代码到十六进制文件的转换
- 使用 MARS 模拟器生成参考输出
- 通过 ISE 进行 Verilog 仿真
- 结果对比与准确性检查

## 快速开始

### 环境要求

- Python 3.x
- MARS MIPS 模拟器(必须是能够和本文件夹中自带的魔改功能一致的)
- Xilinx ISE

### 使用方法

```bash
python mipsFinal.py
```

## 工作流程

1. **代码生成** (`mipsGenerate`)
   - 生成可靠的 MIPS 汇编代码
   - 保存至 `mips.asm`
   - 支持有/无跳转指令生成

2. **汇编转换** (`mips2hex`)
   - 将汇编代码转换为十六进制格式
   - 输出为文本文件

3. **参考执行** (`mipsRunByMars`)
   - 使用 MARS 模拟器执行代码
   - 生成符合课程组格式的 `model_CPU.txt`

4. **Verilog 仿真** (`mipsRunByVerilog`)
   - 使用 ISE 编译和仿真 Verilog 代码
   - 输出仿真结果

5. **结果验证** (`mipsCheck` / `mipsCheckAccuracy`)
   - 对比 MARS 和 Verilog 的执行结果
   - 检查匹配度和准确性

## 命令行参数

支持以下命令行参数：
- `-r` ：Restart：删除所有非`.py`,`.v`,`.jar`,`.md`文件
- `-s` ：Size：指定生成的`blocks`数目
- `-js`：Jump Size：指定`J blocks`大小
- `nj` ：No Jump: 生成无跳转指令的测试

## 注意事项

- `mipsRunByVerilog.py` 参考了 [相关技术博客](https://foreveryolo.top/posts/34987/index.html) 的运行方法
- 当前版本 v0.6.0，您需要在控制台输入路径

## 待办功能

- [x] 配置文件管理工具路径
- [x] 命令行参数支持
- [x] 增加指令执行次数
- [ ] 改进错误报告机制

## 许可证

本项目仅供学习使用。
