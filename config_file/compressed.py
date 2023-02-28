#!/usr/bin/python3
# -*- coding: UTF-8 -*-
import zlib
import base64
import sys

# 待压缩的字符串
for line in sys.stdin:
    line = line.strip() # 去除每行末尾的空格
    string=line

# 压缩字符串
compressed_string = zlib.compress(string.encode('utf-8'))

# 解压缩字符串
decompressed_string = zlib.decompress(compressed_string).decode('utf-8')

# 使用 base64 模块的 b64encode() 函数将压缩后的字符串编码为字符串
u = base64.b64encode(compressed_string)

# 输出结果
print('原始字符串：', string)
print('压缩后的字符串：', u)
print('解压缩后的字符串：', decompressed_string)

print('原始字符串长度：', len(string))
print('压缩后的字符串长度：', len(u))



