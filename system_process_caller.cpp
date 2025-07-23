#include "system_process_caller.h"
#include <QDebug>
#include <QProcess>

SystemProcessCaller::SystemProcessCaller(const int dryRun, QObject *parent) : QObject{parent}, m_dryRun(dryRun) {}

void SystemProcessCaller::poweroff(const QString &reason) {
  QString cmd = QStringLiteral("systemctl");
  QString arg1 = QStringLiteral("poweroff");
  QStringList params{arg1};
  if (m_dryRun) {
    params.append(QStringLiteral("--dry-run"));
  }
  qInfo() << reason << "]run: " << cmd.toStdString() << params;
  QProcess::execute(cmd, params);
};
