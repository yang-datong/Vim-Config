#include <cmath>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

bool insertBytes(const std::string &filename, long offset, int numBytes,
                 const std::vector<uint8_t> &insertData = {}) {
  std::fstream file(filename, std::ios::in | std::ios::out | std::ios::binary);

  if (!file.is_open()) {
    std::cerr << "Error opening file: " << filename << std::endl;
    return false;
  }

  // 获取文件大小
  file.seekg(0, std::ios::end);
  long fileSize = file.tellg();
  file.seekg(0, std::ios::beg);

  // 检查偏移量是否有效
  if (offset < 0 || offset > fileSize) {
    std::cerr << "Invalid offset: " << offset << std::endl;
    return false;
  }

  // 读取偏移量之后的所有数据
  std::vector<char> buffer(fileSize - offset);
  file.seekg(offset);
  file.read(buffer.data(), buffer.size());

  // 准备要插入的数据
  std::vector<uint8_t> dataToInsert;
  if (insertData.empty()) {
    dataToInsert.resize(numBytes, 0x00); // 默认填充 0x00
  } else {
    dataToInsert = insertData;
    if (dataToInsert.size() != (long unsigned int)numBytes) {
      std::cerr << "insertData size not equal numBytes" << std::endl;
      return false;
    }
  }

  // 移动文件指针到插入位置
  file.seekp(offset);

  // 写入要插入的数据
  file.write(reinterpret_cast<const char *>(dataToInsert.data()),
             dataToInsert.size());

  // 写回之前读取的数据
  file.write(buffer.data(), buffer.size());

  file.close();
  return true;
}

bool deleteBytes(const std::string &filename, long offset, int numBytes) {
  std::fstream file(filename, std::ios::in | std::ios::out | std::ios::binary);

  if (!file.is_open()) {
    std::cerr << "Error opening file: " << filename << std::endl;
    return false;
  }

  // 获取文件大小
  file.seekg(0, std::ios::end);
  long fileSize = file.tellg();
  file.seekg(0, std::ios::beg);

  // 检查偏移量和删除字节数是否有效
  if (offset < 0 || offset + numBytes > fileSize) {
    std::cerr << "Invalid offset or number of bytes to delete: " << offset
              << ", " << numBytes << std::endl;
    return false;
  }

  // 读取删除位置之后的所有数据
  std::vector<char> buffer(fileSize - (offset + numBytes));
  file.seekg(offset + numBytes);
  file.read(buffer.data(), buffer.size());

  // 移动文件指针到删除位置
  file.seekp(offset);

  // 写回删除后剩下的数据
  file.write(buffer.data(), buffer.size());

  // 截断文件
  file.close();
  return true;
}

static int to_int(std::string &s, long &n) {
  if (s[0] == '0' && s[1] == 'x') {
    n = std::stoi(s.c_str(), nullptr, 16);
  } else {
    try {
      n = std::stoi(s.c_str());
    } catch (const std::invalid_argument &e) {
      std::cerr << "Out of range: " << e.what() << std::endl;
      return -1;
    }
  }
  return 0;
}

static int to_int(std::string &s, int &n) {
  if (s[0] == '0' && s[1] == 'x') {
    n = std::stoi(s.c_str(), nullptr, 16);
  } else {
    try {
      n = std::stoi(s.c_str());
    } catch (const std::invalid_argument &e) {
      std::cerr << "Out of range: " << e.what() << std::endl;
      return -1;
    }
  }
  return 0;
}

int main(int argc, char *argv[]) {
  if (argc < 5) {
    std::cerr << "Use: ./tools --[insert|delete] file offset size" << std::endl;
    return 0;
  }

  std::string op = argv[1];
  std::string file_name = argv[2];
  std::string s3(argv[3]);
  std::string s4(argv[4]);
  long offset = 0;
  int numBytes = 0;
  to_int(s3, offset);
  to_int(s4, numBytes);

  int ret;
  if (op == "--insert") {
    ret = insertBytes(file_name, offset, numBytes);
  } else if (op == "--delete") {
    ret = deleteBytes(file_name, offset, numBytes);
  } else {
    std::cerr << "Use: ./tools --[insert|delete] file offset size" << std::endl;
    return 0;
  }

  if (ret) {
    std::cout << "Successfully." << std::endl;
  } else {
    std::cout << "Error." << std::endl;
  }
  return 0;
}
