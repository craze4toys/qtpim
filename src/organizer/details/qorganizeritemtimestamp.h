/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/
**
** This file is part of the QtOrganizer module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU General
** Public License version 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of this
** file. Please review the following information to ensure the GNU General
** Public License version 3.0 requirements will be met:
** http://www.gnu.org/copyleft/gpl.html.
**
** Other Usage
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef QORGANIZERITEMTIMESTAMP_H
#define QORGANIZERITEMTIMESTAMP_H

#include <qorganizeritemdetail.h>

#include <QtCore/qdatetime.h>

QTORGANIZER_BEGIN_NAMESPACE

/* Leaf class */

class Q_ORGANIZER_EXPORT QOrganizerItemTimestamp : public QOrganizerItemDetail
{
public:
#ifndef Q_QDOC
    Q_DECLARE_CUSTOM_ORGANIZER_DETAIL(QOrganizerItemTimestamp, QOrganizerItemDetail::TypeTimestamp)
#endif

    enum TimestampField {
        FieldCreated = TypeTimestamp + 1,
        FieldLastModified
    };

    void setCreated(const QDateTime &timestamp);
    QDateTime created() const;

    void setLastModified(const QDateTime &timestamp);
    QDateTime lastModified() const;
};

QTORGANIZER_END_NAMESPACE

#endif // QORGANIZERITEMTIMESTAMP_H
