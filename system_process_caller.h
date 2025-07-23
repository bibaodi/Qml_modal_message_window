#ifndef SYSTEM_PROCESS_CALLER_H
#define SYSTEM_PROCESS_CALLER_H

#include <QObject>

class SystemProcessCaller : public QObject {
  Q_OBJECT
public:
  explicit SystemProcessCaller(const int dryRun = 0, QObject *parent = nullptr);
  Q_INVOKABLE void poweroff(const QString &reason);
signals:
private:
  int m_dryRun{0};
};

#endif // SYSTEM_PROCESS_CALLER_H
