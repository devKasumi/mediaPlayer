#include "player.h"
#include "playlistmodel.h"

#include <QMediaService>
#include <QMediaPlaylist>
#include <QMediaMetaData>
#include <QObject>
#include <QFileInfo>
#include <QTime>
#include <QDir>
#include <QStandardPaths>
#include <QDebug>



Player::Player(QObject *parent)
    : QObject{parent}
{
    m_player = new QMediaPlayer(this);
    m_playlist = new QMediaPlaylist(this);
    m_player->setPlaylist(m_playlist);
    m_playlistModel = new PlaylistModel(this);
    open();
    if(!m_playlist->isEmpty()){
        m_playlist->setCurrentIndex(0);
    }
}

void Player::addToPlaylist(const QList<QUrl> &urls)
{
    for (auto &url : urls) {
        m_playlist->addMedia(url);
        const char * path = url.path().toStdString().c_str();
        path++;
        FileRef f(path);
        Tag *tag = f.tag();
        Song song(QString::fromWCharArray(tag->title().toCWString()),
                  QString::fromWCharArray(tag->artist().toCWString()),
                  url.toDisplayString(),
                  //getAlbumArt(url));
                  getAlbumArt(dynamic_cast<TagLib::MPEG::File*>(f.file())));
        m_playlistModel->addSong(song);
    }
}

void Player::open()
{
    QDir directory(QStandardPaths::standardLocations(QStandardPaths::MusicLocation)[0]);
    QFileInfoList musics = directory.entryInfoList(QStringList() << "*.mp3", QDir::Files);
    QList<QUrl> urls;
    for (int i = 0; i < musics.length(); i++){
        urls.append(QUrl::fromLocalFile(musics[i].absoluteFilePath()));
    }
    addToPlaylist(urls);
}

QString Player::getTimeInfo(qint64 currentInfo)
{
    QString tStr = "00:00";
    currentInfo = currentInfo/1000;
    qint64 duration = m_player->duration()/1000;
    if (currentInfo || duration){
        QTime currentTime((currentInfo / 3600) % 60, (currentInfo / 60) % 60,
                          currentInfo % 60, (currentInfo * 1000) % 1000);
        QTime totalTime((duration / 3600) % 60, (m_player->duration() / 60) % 60,
                        duration % 60, (m_player->duration() * 1000) % 1000);
        QString format = "mm:ss";
        if (duration > 3600)
            format = "hh::mm:ss";
        tStr = currentTime.toString(format);
    }
    return tStr;
}

QString Player::getAlbumArt(MPEG::File* mpegFile)
{
    static const char *IdPicture = "APIC" ;
    TagLib::ID3v2::Tag *id3v2tag = mpegFile->ID3v2Tag();
    TagLib::ID3v2::FrameList Frame ;
    TagLib::ID3v2::AttachedPictureFrame *PicFrame ;
    void *SrcImage ;
    unsigned long Size ;

    FILE *jpegFile;
    auto name = mpegFile->name();
    char m_name[100];
    strcpy(m_name,name);
    char * filename = strcat(m_name,".jpg");
    jpegFile = fopen(filename,"wb");

    if (id3v2tag){
        // picture frame
        Frame = id3v2tag->frameListMap()[IdPicture];
        if (!Frame.isEmpty()){
            for (TagLib::ID3v2::FrameList::ConstIterator it = Frame.begin(); it != Frame.end(); it++){
                PicFrame = static_cast<TagLib::ID3v2::AttachedPictureFrame*>(*it);
                if (PicFrame->type() == TagLib::ID3v2::AttachedPictureFrame::FrontCover){
                    // extract image (in it's compressedd form)
                    Size = PicFrame->picture().size();
                    SrcImage = malloc(Size);
                    if (SrcImage){
                        memcpy(SrcImage, PicFrame->picture().data(), Size);
                        fwrite(SrcImage, Size, 1, jpegFile);
                        fclose(jpegFile);
                        free(SrcImage);
                        qDebug() << "source : " << QUrl::fromLocalFile(QString(filename)).toDisplayString();
                        return QUrl::fromLocalFile(QString(filename)).toDisplayString();

                    }
                }
            }
        }
    }
    else {
        qDebug() << "id3v2 not present";
        return "qrc:/Image/album_art.png";
    }
    return "qrc:/Image/album_art.png";
}




























