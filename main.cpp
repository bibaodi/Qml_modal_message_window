#include "system_process_caller.h"
#include <QCommandLineParser>
#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

void initCliParser(QCommandLineParser &parser) {
  parser.setApplicationDescription(QStringLiteral("SIHO Crash Infomation Window with CLI parameters"));
  parser.addHelpOption();

  QCommandLineOption levelOption({"L", "level"}, "Set the level", "level", "error");
  QCommandLineOption textOption({"M", "message"}, "Message text to display", "text", "Message");
  QCommandLineOption dryrunOption("dryrun", "not invoke system poweroff just print");

  parser.addOption(levelOption);
  parser.addOption(textOption);
  parser.addOption(dryrunOption);
}

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);
  QCommandLineParser parser;
  initCliParser(parser);

  parser.process(app);

  QString messageLevel = parser.value(QStringLiteral("level"));
  QString messageText = parser.value(QStringLiteral("message"));
  messageText.replace("\\n", "\n");
  int useDryrun = static_cast<int>(parser.isSet(QStringLiteral("dryrun")));
  qDebug() << "options:useDryrun=" << useDryrun;

  QQmlApplicationEngine engine;
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

  engine.rootContext()->setContextProperty(QStringLiteral("displayText"), messageText);
  engine.rootContext()->setContextProperty(QStringLiteral("messageLevel"), messageLevel);
  SystemProcessCaller systemProcessCaller(useDryrun);
  engine.rootContext()->setContextProperty(QStringLiteral("qmlSystemProcessCaller"), &systemProcessCaller);

  engine.loadFromModule(QStringLiteral("siho-crashInfomationWindow"), QStringLiteral("Main"));
  app.exec();

  systemProcessCaller.poweroff(QStringLiteral("app exit"));
}
