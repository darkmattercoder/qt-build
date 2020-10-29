#include <QDebug>
#include <QDir>
//#define PLUGIN_DIR "plugindir"
int main() {
  QString platformDir = QString(PLUGIN_DIR) + "/platforms";
  qDebug() << "searching plugin in directory " << platformDir;
  QDir pluginDir(platformDir);
  QStringList platformPlugins = pluginDir.entryList();
  qDebug() << "plugins found in file system: " << platformPlugins;
  if (platformPlugins.contains("libqxcb.so")) {
	qDebug() << "xcb plugin found";
	return 0;
  }
  qDebug() << "xcb plugin not found";
  return 1;
}
