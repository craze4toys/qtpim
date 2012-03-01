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


#ifndef QORGANIZERITEMREMOVEBYIDREQUEST_H
#define QORGANIZERITEMREMOVEBYIDREQUEST_H

#include "qorganizerglobal.h"
#include "qorganizerabstractrequest.h"
#include "qorganizeritemfilter.h"

#include <QList>

QTORGANIZER_BEGIN_NAMESPACE

class QOrganizerItemRemoveByIdRequestPrivate;
class Q_ORGANIZER_EXPORT QOrganizerItemRemoveByIdRequest : public QOrganizerAbstractRequest
{
    Q_OBJECT

public:
    QOrganizerItemRemoveByIdRequest(QObject* parent = 0);
    ~QOrganizerItemRemoveByIdRequest();

    /* Selection */
    void setItemId(const QOrganizerItemId& organizeritemId);
    void setItemIds(const QList<QOrganizerItemId>& organizeritemIds);
    QList<QOrganizerItemId> itemIds() const;

    /* Results */
    QMap<int, QOrganizerManager::Error> errorMap() const;

private:
    Q_DISABLE_COPY(QOrganizerItemRemoveByIdRequest)
    friend class QOrganizerManagerEngine;
    Q_DECLARE_PRIVATE_D(d_ptr, QOrganizerItemRemoveByIdRequest)
};

QTORGANIZER_END_NAMESPACE

#endif
