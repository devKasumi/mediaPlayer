#ifndef TRANSLATION_H
#define TRANSLATION_H

#include <QObject>
#include <QTranslator>
#include <QGuiApplication>

class Translation : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString getEmptyString READ getEmptyString NOTIFY languageChanged)
    Q_PROPERTY(QString currentLanguage READ currentLanguage NOTIFY currentLanguageChanged)
public:
    explicit Translation(QGuiApplication* app, QObject *parent = nullptr);
    QString getEmptyString();
    Q_INVOKABLE QString currentLanguage();
    void setCurrentLanguage(QString language);
    Q_INVOKABLE void selectLanguage(QString language);

    const QString &name() const;

signals:
    void languageChanged();
    void currentLanguageChanged();
private:
    QTranslator *translator1;
    QTranslator *translator2;
    QGuiApplication *m_app;
    QString m_currentLanguage;

};

#endif // TRANSLATION_H
