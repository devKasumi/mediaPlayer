#include "translation.h"

Translation::Translation(QGuiApplication *app, QObject *parent)
{
    translator1 = new QTranslator(this);
    translator2 = new QTranslator(this);
//    translator1->load(":/translator/string_us.qm");
//    m_app->installTranslator(translator1);
//    app = m_app;
}

QString Translation::getEmptyString()
{
    return "";
}

QString Translation::currentLanguage()
{
    return m_currentLanguage;
}

void Translation::setCurrentLanguage(QString language)
{
    m_currentLanguage = language;
    emit currentLanguageChanged();
}

void Translation::selectLanguage(QString language)
{
    m_currentLanguage = language;
    if (m_currentLanguage == "us"){
        translator1->load(":/translator/string_us.qm");
        m_app->installTranslator(translator1);
        m_app->removeTranslator(translator2);
    }
    else{
        translator2->load(":/translator/string_vn.qm");
        m_app->installTranslator(translator2);
        m_app->removeTranslator(translator1);
    }
    emit languageChanged();
    emit currentLanguageChanged();
}

