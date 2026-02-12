# PDC — Production Data Collection System
# Kyocera AVX | Harbour 3.0.0 | ADS RDD
# Рабочие заметки проекта

## Что это

Система сбора производственных данных (PDC) для завода Kyocera AVX.
Сканирование штрих-кодов, контроль качества, перемещение партий по линиям,
печать этикеток, отчёты по отгрузке и yield.

Язык: Harbour 3.0 (порт с Clipper 5.x).
БД: Advantage Database Server (ADS) через RDD, таблицы DBF.
UI: консольный (GT=GTWIN), browse, формы, popup-меню.

## Структура проекта

```
PDC/
├── pdc.hbp              # Harbour build project (hbmk2)
├── pdc.exe.xbp          # xBuild/xEdit project
├── build.bat            # Скрипт сборки
├── include/             # Header-файлы (.CH)
│   ├── AVXDEFS.CH       # Главный — константы, пути, RDD, define
│   ├── ABROWSER.CH      # Array browser макросы
│   ├── CHECKS.CH        # Checkbox UI
│   ├── COMBOBOX.CH      # Combobox UI
│   ├── EDI.CH           # EDI-интерфейс
│   ├── NETTO.CH         # Сетевые константы
│   ├── RADIOBTN.CH      # Radio buttons
│   ├── LFNLIB.ch        # Long File Name (заглушка, в Harbour нативно)
│   └── ...DEF.CH        # Дополнительные define-файлы
├── lib/                 # Библиотечные модули
│   ├── TABBASE.prg      # ★ TabBase class — обёртка таблиц/индексов
│   ├── FORM.PRG         # ★ Form class — окна/диалоги с тенью
│   ├── USERINFO.PRG     # ★ UserInfo class — пользователь, принтеры, INI
│   ├── LOCKS.PRG        # ★ RecLock, NetUse, AddRec, FilLock
│   ├── INDXINFO.PRG     # ★ LoadIndexInfo — метаданные индексов
│   ├── MSGKEYS.PRG      # ★ Msg24/Keys24 — статусная строка
│   ├── SHADOW.PRG       # ★ Shadow() — тень для окон
│   └── (заглушки)       # остальные — ждут загрузки с шары
└── *.PRG                # Основные модули приложения
```

★ = реальный файл загружен

## Основные PRG-модули

| Файл | Назначение |
|---|---|
| BMSBAR.PRG | Главный вход: сканирование штрих-кода, статус партии, workflow |
| BMSBAR2.PRG | Печать штрих-кодов, WIP количества, допуски |
| BMSBAR3.PRG | QC/ESN финальная проверка, атрибуты, завершение партии |
| BMSBAR4.PRG | Генерация QC-документов для готовой продукции |
| BMSBAR5.PRG | QC pack — проверка упаковки |
| LMVCENTR.PRG | Контроллер перемещений — переход партий между стадиями |
| STOKWORK.PRG | Запрос WIP по рабочей станции |
| STOKPROC.PRG | Запрос WIP по процессу |
| BNPATH.PRG | Маршрут партии — история перемещений по линиям |
| QPQC37V1.PRG | Отчёт по отгрузке (AWB, batch number) |
| RPQC36V1.prg | Анализ yield — спеки, допуски, производительность |
| SUBMENU.prg | Класс popup-меню с навигацией |
| FUNCS.PRG | YosUse — подключение к БД с retry |
| MISCALL.PRG | Форма задач/вызовов |
| HELPKYS1.PRG | Справка — горячие клавиши |
| TAPILABS.PRG | Печать этикеток (Kyocera) |
| PRODLABS.prg | Печать продуктовых этикеток |
| NEGA.PRG | Проверка на отрицательные значения |

## Библиотеки (lib/) — что есть, чего нет

### Загружены (реальные):
- **TABBASE.prg** — TabBase class: init, setIndexList, SetOrder, xopen, xopenTemp, close
- **FORM.PRG** — Form class: init, say, sayBottom, hide, cls + тени
- **USERINFO.PRG** — UserInfo class: init, xopen, getDirectory, canProcess, readMapFile, GetPrinterArray, LoadUserIni
- **LOCKS.PRG** — AddRec(), FilLock(), NetUse(), RecLock() + система блокировок control-таблицы
- **INDXINFO.PRG** — LoadIndexInfo(), GetFileIndexInfo()
- **MSGKEYS.PRG** — Msg24(), Keys24()
- **SHADOW.PRG** — Shadow()

### Заглушки (ждут загрузки с \\\\10.10.49.156\\Share):
- report.prg — генерация отчётов
- brocent.prg — центрирование browse
- avxfuncs.prg — общие функции AVX
- stdkeys.prg — стандартный обработчик клавиш
- scrn.prg — сохранение/восстановление экрана
- abrowse.prg — array browse
- netto.prg — сетевые утилиты
- slack.prg — Slack-уведомления
- barc.prg — утилиты штрих-кодов
- critbrow.prg — criteria browse
- security.prg — авторизация
- hebreader.prg — чтение Hebrew текста
- f2key.prg — обработчик F2

## Сборка

```bat
REM Через hbmk2:
hbmk2 pdc.hbp

REM Или через build.bat:
build.bat
```

Требует: Harbour 3.0 (`C:\hb30`), MinGW, ADS Client (rddads).

## Что сделано

1. Портирование с Clipper на Harbour 3.0:
   - AVXDEFS.CH адаптирован (hbclass.ch, Harbour-совместимые define)
   - build.bat + pdc.hbp + pdc.exe.xbp
2. Загружены все 19 основных PRG
3. Загружены 12 CH-файлов в include/
4. Загружено 7 реальных lib-файлов
5. Созданы заглушки для 13 недостающих lib-файлов
6. LFNLIB.ch — заглушка (в Harbour LFN нативный)

## Что осталось

- [ ] Загрузить оставшиеся 13 lib-файлов с сетевой шары
- [ ] Проверить компиляцию на Windows с Harbour 3.0
- [ ] Разобрать ошибки линковки (недостающие функции из заглушек)
- [ ] Проверить совместимость ADS-вызовов
- [ ] Тестирование подключения к БД
