#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Путь к корневой папке проекта iOS
const iosPlatformPath = path.join(process.cwd(), 'platforms', 'ios');

// Чтение config.xml, чтобы найти имя приложения (CFBundleName)
const configPath = path.join(process.cwd(), 'config.xml');
const configContent = fs.readFileSync(configPath, 'utf-8');
const appNameMatch = configContent.match(/<name>(.*?)<\/name>/);

if (!appNameMatch || appNameMatch.length < 2) {
    console.error('Error: Unable to determine app name from config.xml');
    process.exit(1);
}

const appName = appNameMatch[1].trim();
const swiftHeader = `${appName}-Swift.h`;
const importLine = `#import "${swiftHeader}"\n`;

// Путь к файлу, где нужно добавить импорт
const targetFilePath = path.join(iosPlatformPath, 'Plugins', 'cordova-plugin-liveactivity', 'LiveActivity.m');

// Проверяем, существует ли файл
if (fs.existsSync(targetFilePath)) {
    // Читаем содержимое файла
    let fileContent = fs.readFileSync(targetFilePath, 'utf-8');

    // Если импорт уже есть, ничего не делаем
    if (!fileContent.includes(importLine)) {
        // Добавляем импорт в начало файла
        fileContent = importLine + fileContent;
        fs.writeFileSync(targetFilePath, fileContent, 'utf-8');
        console.log(`Successfully added import: ${swiftHeader}`);
    } else {
        console.log(`Import already exists: ${swiftHeader}`);
    }
} else {
    console.error(`Error: Target file not found at ${targetFilePath}`);
}
