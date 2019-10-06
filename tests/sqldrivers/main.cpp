#include <QDebug>
#include <QSqlDatabase>

int main()
{
  auto drivers = QSqlDatabase::drivers();
  qDebug() << "Available drivers:" << drivers;

  if (!drivers.contains("QMYSQL") || !drivers.contains("QPSQL"))
    return 1;

  return 0;
}
