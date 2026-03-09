# HRT Helper with Flutter

This is a fork of **[Oyama-s-HRT-Tracker](https://www.google.com/url?sa=E&q=https%3A%2F%2Fgithub.com%2FSmirnovaOyama%2FOyama-s-HRT-Tracker)**, focused on refactoring the app with **Flutter**. Our goal is to provide a seamless user experience by releasing full Android (apk) and iOS (ipa) builds.<br>

We would like to express our sincere gratitude to **@LaoZhong-Mihari** and **@SmirnovaOyama** for their exceptional contributions 😺.<br>

本项目是 **[Oyama-s-HRT-Tracker](https://github.com/SmirnovaOyama/Oyama-s-HRT-Tracker)** 的项目分支，致力于采用**Flutter**前端框架重构应用并发布 Android (apk) 和 IOS (ipa) 完整应用包，为用户提供更便捷的体验。<br>

此处特别鸣谢 **@LaoZhong-Mihari，@SmirnovaOyama**的卓越工作😺。<br>



## Algorithm & Core Logic 算法逻辑

The pharmacokinetic algorithms, mathematical models, and parameters used in this simulation are derived directly from the **[HRT-Recorder-PKcomponent-Test](https://github.com/LaoZhong-Mihari/HRT-Recorder-PKcomponent-Test)** repository.<br>

本模拟中使用的药代动力学算法、数学模型与相关参数，直接来源于 **[HRT-Recorder-PKcomponent-Test](https://github.com/LaoZhong-Mihari/HRT-Recorder-PKcomponent-Test)** 仓库。

We strictly adhere to the `PKcore.swift` and `PKparameter.swift` logic provided by **@LaoZhong-Mihari**, ensuring that the web simulation matches the accuracy of the original native implementation (including 3-compartment models, two-part depot kinetics, and specific sublingual absorption tiers).<br>

我们严格遵循 **@LaoZhong-Mihari** 提供的 `PKcore.swift` 与 `PKparameter.swift` 中的逻辑，确保应用端模拟与原生实现在精度上保持一致（包括三室模型、双相肌注库房动力学以及特定的舌下吸收分层等）。



## Features 功能

* **Multi-Route Simulation**: Supports Injection (Valerate, Benzoate, Cypionate, Enanthate), Oral, Sublingual, Gel, and Patches.<br>

  **多给药途径模拟**：支持注射（戊酸酯 Valerate、苯甲酸酯 Benzoate、环戊丙酸酯 Cypionate、庚酸酯 Enanthate）、口服、舌下、凝胶以及贴片等多种给药方式。<br>

* **Real-time Visualization**: Interactive charts showing estimated estradiol concentration (pg/mL) over time.<br>

  **实时可视化**：通过交互式图表展示随时间变化的雌二醇估算浓度（pg/mL）。<br>

* **Sublingual Guidance**: Detailed "Hold Time" and absorption parameter ($\theta$) guidance based on strict medical modeling.<br>

  **舌下服用指导**：基于严格的医学建模，提供详细的含服时间与吸收参数（$\theta$）参考。<br>

* **Privacy First**: All data is stored entirely in your device's `localStorage`. No data will be ever sent to a server without your authorization.<br>

  **隐私优先**：所有数据都完全存储在您设备的 `localStorage` 中，绝不会主动发送到任何服务器。<br>

* **Internationalization**: Native support for **Simplified Chinese**,  **Traditional Chinese**, **English** and **Japanese**.<br>

  **多语言支持**：原生支持 **简体中文、繁体中文、英语、日本语**。<br>

* **Cloud Backup**: Support for uploading your local personal data to third-party cloud drives such as `Google Drive`, `One Drive`, `Baiduyun Drive` and `Huawei Cloud` using official apis.<br>
**云端备份支持**：利用官方接口允许您将本地数据备份至`Google Drive`、`One Drive`、`百度云盘`和`华为云空间`等第三方网盘。


# License 开源协议
MIT License 🦖

# After All 写在最后
Thanking you for visiting this repo. We wish you a healthy body and happy life.😘<br>
感谢您关注本仓库，祝您身体健康生活愉快。😘