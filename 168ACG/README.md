# 168 Keyboard Activation Code Generator

[中文说明](#中文说明) | [English Description](#english-description)

---

## 中文说明

### 概览

本项目是一个实现特定激活码生成算法的iOS应用，用于为"168键盘"生成激活码。它从一个核心算法脚本开始，逐步演变为一个功能齐全、界面美观且用户体验良好的iOS原生应用。

整个开发过程展示了如何将一个核心算法逻辑（基于HMAC-SHA256）封装到一个现代化的移动应用中，并围绕它构建用户友好的功能和界面。

### ✨ 功能特性

- **精准的算法实现**: 精确实现了HMAC-SHA256哈希算法和特定的激活码生成逻辑。
- **现代化UI/UX**:
  - **卡片式设计**: 使用带有阴影和圆角的卡片来组织内容，使界面清晰、有层次感。
  - **渐变背景**: 柔和的渐变色背景，提升了应用的视觉吸引力。
  - **流畅动画**: 包含加载、成功、错误提示等多种动画效果，提供了丰富的交互反馈。
- **便捷的操作**:
  - **一键获取UUID**: 用户可以轻松获取设备的`identifierForVendor`作为生成激活码的源字符串。
  - **一键复制**: 生成的激活码可以方便地复制到剪贴板。
- **丰富的信息提示**:
  - **使用须知**: 在界面中明确告知用户UUID的特性以及应用的使用目的。
  - **页脚声明**: 包含"交流学习，请勿违法"的提示信息。

### ⚙️ 工作原理

激活码的生成遵循一个固定的加密和编码规则：

1.  **密钥和设备码**: 使用一个固定的密钥（`KeyboardTheme2023ActivationSecret`）和一个长度至少为20个字符的设备码（UUID）作为输入。
2.  **HMAC-SHA256哈希**: 对设备码使用密钥进行HMAC-SHA256哈希计算，生成一个64位的十六进制哈希字符串。
3.  **字符选择与格式化**:
    - 循环24次，每次根据 `(7 * i + 3) % len(hash_result)` 规则从哈希字符串中取出一个字符。
    - 每4个字符添加一个连字符 `-`。
    - 最终生成一个 `XXXX-XXXX-XXXX-XXXX-XXXX-XXXX` 格式的24位激活码。
4.  **大写转换**: 将生成的激活码全部转换为大写。

### 🚀 如何构建和运行

1.  **环境要求**:
    - macOS 系统
    - Xcode 12 或更高版本
2.  **步骤**:
    - 克隆或下载本仓库。
    - 使用 Xcode 打开 `168ACG.xcodeproj` 项目文件。
    - 连接一个iOS设备或选择一个iOS模拟器。
    - 点击 "Build and Run" 按钮 (▶️) 来编译和运行应用。

### ⚠️ 免责声明

本项目仅用于学习和技术交流，旨在演示如何将一个核心算法逻辑转换为功能完善的iOS原生应用。

**请勿将此项目用于任何非法或商业用途。** 用户在使用过程中产生的一切后果，与项目作者无关。

---

## English Description

### Overview

This project is an iOS application that implements a specific activation code generation algorithm for the "168 Keyboard." It evolved from a core algorithm script into a full-featured, visually appealing, and user-friendly native iOS application.

The development process demonstrates how to encapsulate a core algorithm logic (based on HMAC-SHA256) into a modern mobile app, building user-friendly features and a polished interface around it.

### ✨ Features

- **Accurate Algorithm Implementation**: Faithfully implements the HMAC-SHA256 hashing algorithm and a specific activation code generation logic.
- **Modern UI/UX**:
  - **Card-Based Design**: Uses cards with shadows and rounded corners to organize content, creating a clean and layered interface.
  - **Gradient Background**: A soft gradient background enhances the app's visual appeal.
  - **Smooth Animations**: Provides rich interactive feedback with various animations for loading, success, and error states.
- **Convenient Operations**:
  - **One-Click Get UUID**: Allows users to easily fetch the device's `identifierForVendor` as the source string for the activation code.
  - **One-Click Copy**: The generated activation code can be easily copied to the clipboard.
- **Informative Guidance**:
  - **Usage Notes**: Clearly informs users about the characteristics of the UUID and the intended purpose of the application.
  - **Footer Disclaimer**: Includes a notice stating, "For communication and learning purposes, please do not use for illegal activities."

### ⚙️ How It Works

The activation code generation follows a fixed encryption and encoding process:

1.  **Key and Device Code**: It uses a fixed secret key (`KeyboardTheme2023ActivationSecret`) and a device code (UUID) of at least 20 characters as input.
2.  **HMAC-SHA256 Hash**: It computes an HMAC-SHA256 hash of the device code using the secret key, resulting in a 64-character hexadecimal hash string.
3.  **Character Selection & Formatting**:
    - It iterates 24 times, picking a character from the hash string based on the rule `(7 * i + 3) % len(hash_result)`.
    - A hyphen `-` is inserted every 4 characters.
    - This creates a 24-character activation code in the format `XXXX-XXXX-XXXX-XXXX-XXXX-XXXX`.
4.  **Uppercase Conversion**: The final activation code is converted to uppercase.

### 🚀 How to Build and Run

1.  **Requirements**:
    - macOS
    - Xcode 12 or later
2.  **Steps**:
    - Clone or download this repository.
    - Open the `168ACG.xcodeproj` project file with Xcode.
    - Connect an iOS device or select an iOS simulator.
    - Click the "Build and Run" button (▶️) to compile and run the application.

### ⚠️ Disclaimer

This project is for educational and technical communication purposes only. It aims to demonstrate how a core algorithm can be converted into a fully functional native iOS application.

**Do not use this project for any illegal or commercial purposes.** The author is not responsible for any consequences arising from the use of this project. 