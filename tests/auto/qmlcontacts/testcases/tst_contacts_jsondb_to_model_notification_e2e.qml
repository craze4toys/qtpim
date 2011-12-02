/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the QtPim module of the Qt Toolkit.
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
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtTest 1.0
import QtContacts 5.0
import QtAddOn.JsonDb 1.0

ContactsSavingTestCase {
    name: "ContactsJsonDbToModelNotificationE2ETests"
    id: contactsJsonDbToModelNotificationE2ETests

    property ContactModel model

    function createModel() {
        model = Qt.createQmlObject(
                    'import QtContacts 5.0;' +
                    'ContactModel {' +
                        'manager: "jsondb";' +
                        'autoUpdate: true;' +
                    '}',
                    contactsJsonDbToModelNotificationE2ETests);
    }

    function test_createContactShouldUpdateModel()
    {
        initTestForModel(model);

        createContactToJsonDb({});

        waitForContactsChanged();

        compare(model.contacts.length, 1, "model has a contact");
    }

    function test_createContactPassesDetailsToModel()
    {
        initTestForModel(model);

        createContactToJsonDb({name: {firstName: "Test"}
                              });

        waitForContactsChanged();

        verify(model.contacts[0].name, "name exists");
        compare(model.contacts[0].name.firstName, "Test", "first name");
    }

    Contact {
        id: contactToBeRemoved
    }

    function test_removeContactShouldUpdateModel()
    {
        initTestForModel(model);

        model.saveContact(contactToBeRemoved);
        waitForContactsChanged();

        var contact = model.contacts[0];
        verify(contact);
        removeContactFromJsonDb(contact);

        waitForContactsChanged();

        compare(model.contacts.length, 0, "model is empty");
    }

    function pending_removeMultipleContactShouldUpdateModel() {
    }

    function pending_removeOnlySomeContactsShouldLeaveOthersAsTheyWere() {
    }

    Contact {
        id: contactToBeUpdated
        Name {
            firstName: "old"
        }
    }

    function test_updateContactShouldUpdateModel()
    {
        initTestForModel(model);

        model.saveContact(contactToBeUpdated);
        waitForContactsChanged();

        var contact = model.contacts[0];
        updateContactInJsonDb(contact, {name: {firstName: "new"}});

        waitForContactsChanged();

        compare(model.contacts.length, 1, "model is not empty");
        compare(model.contacts[0].name.firstName, "new", "first name");
    }

    SortOrder {
        id: sortByFirstName
        detail: ContactDetail.Name
        field: Name.FirstName
        direction: Qt.AscendingOrder
    }

    Contact {
        id: sorting_creating_secondContact
        Name {
            firstName: "B"
        }
    }

    function test_createContactSortsContactsInModel()
    {
        initTestForModel(model);
        model.sortOrders = [sortByFirstName];
        waitForContactsChanged();

        model.saveContact(sorting_creating_secondContact);
        waitForContactsChanged();
        createContactToJsonDb({name: {firstName: "A"}});
        waitForContactsChanged();

        compare(model.contacts.length, 2, "contacts length");
        compare(model.contacts[0].name.firstName, "A", "first contact");
        compare(model.contacts[1].name.firstName, "B", "second contact");
    }

    Contact {
        id: sorting_updating_firstContact
        Name {
            firstName: "B"
        }
    }

    Contact {
        id: sorting_updating_secondContact
        Name {
            firstName: "C"
        }
    }

    function test_updateContactDetailSortsContactsInModel()
    {
        initTestForModel(model);
        model.sortOrders = [sortByFirstName];
        waitForContactsChanged();

        model.saveContact(sorting_updating_firstContact);
        waitForContactsChanged();
        model.saveContact(sorting_updating_secondContact);
        waitForContactsChanged();

        var contact = model.contacts[1];
        compare(contact.name.firstName, "C", "second contact first name");
        updateContactInJsonDb(contact, {name: {firstName: "A"}});

        waitForContactsChanged();

        compare(model.contacts.length, 2, "contacts length");
        compare(model.contacts[0].name.firstName, "A", "first contact");
        compare(model.contacts[1].name.firstName, "B", "second contact");
    }

    Contact {
        id: sorting_removing_firstContact
        Name {
            firstName: "A"
        }
    }

    Contact {
        id: sorting_removing_secondContact
        Name {
            firstName: "B"
        }
    }

    Contact {
        id: sorting_removing_thirdContact
        Name {
            firstName: "C"
        }
    }

    function test_removeContactSortsContactsInModel()
    {
        initTestForModel(model);
        model.sortOrders = [sortByFirstName];
        waitForContactsChanged();

        model.saveContact(sorting_removing_thirdContact);
        waitForContactsChanged();
        model.saveContact(sorting_removing_secondContact);
        waitForContactsChanged();
        model.saveContact(sorting_removing_firstContact);
        waitForContactsChanged();

        var contact = model.contacts[1];
        removeContactFromJsonDb(contact);

        waitForContactsChanged();

        compare(model.contacts.length, 2, "contacts length");
        compare(model.contacts[0].name.firstName, "A", "first contact");
        compare(model.contacts[1].name.firstName, "C", "second contact");
    }

    DetailFilter {
        id: filterByFirstName
        detail: ContactDetail.Name
        field: Name.FirstName
        matchFlags: Filter.MatchExactly
    }

    function test_createContactMatchingTheFilter()
    {
        initTestForModel(model);
        filterByFirstName.value = "A";
        model.filter = filterByFirstName;
        waitForContactsChanged();

        createContactToJsonDb({name: {firstName: "A"}});
        waitForContactsChanged();

        compare(model.contacts.length, 1, "contacts length");
        compare(model.contacts[0].name.firstName, "A", "first name");
    }

    function test_createContactNotMatchingTheFilter()
    {
        initTestForModel(model);
        filterByFirstName.value = "A";
        model.filter = filterByFirstName;
        waitForContactsChanged();

        createContactToJsonDb({name: {firstName: "B"}});
        waitForContactsChanged();

        compare(model.contacts.length, 0, "contacts length");
    }

    Contact {
        id: filtering_removing_matchingContact
        Name {
            firstName: "A"
        }
    }

    function test_removeContactMatchingTheFilter()
    {
        initTestForModel(model);
        filterByFirstName.value = "A";
        model.filter = filterByFirstName;
        waitForContactsChanged();

        model.saveContact(filtering_removing_matchingContact);
        waitForContactsChanged();

        var contact = model.contacts[0];
        removeContactFromJsonDb(contact);
        waitForContactsChanged();

        compare(model.contacts.length, 0, "contacts length");
    }

    Contact {
        id: filtering_removing_nonmatchingContact
        Name {
            firstName: "B"
        }
    }

    function test_removeContactNotMatchingTheFilter()
    {
        initTestForModel(model);

        model.saveContact(filtering_removing_nonmatchingContact);
        waitForContactsChanged();
        var id = model.contacts[0].contactId;

        filterByFirstName.value = "A";
        model.filter = filterByFirstName;
        waitForContactsChanged();

        compare(model.contacts.length, 0, "contacts length");

        var count = spy.count;
        removeContactFromJsonDb({contactId: id});

        wait(500);
        compare(spy.count, count, "spy does not receive a signal");
    }

    Contact {
        id: filtering_updating_nonmatchingContact
        Name {
            firstName: "B"
        }
    }

    function test_updateContactDetailToMatchTheFilter()
    {
        initTestForModel(model);

        model.saveContact(filtering_updating_nonmatchingContact);
        waitForContactsChanged();
        var id = model.contacts[0].contactId;

        filterByFirstName.value = "A";
        model.filter = filterByFirstName;
        waitForContactsChanged();

        compare(model.contacts.length, 0, "model is empty");

        updateContactInJsonDb({contactId: id}, {name: {firstName: "A"}});

        waitForContactsChanged();

        compare(model.contacts.length, 1, "model is not empty");
        compare(model.contacts[0].name.firstName, "A", "first name");
    }

    Contact {
        id: filtering_updating_matchingContact
        Name {
            firstName: "A"
        }
    }

    function test_updateContactDetailToNotMatchTheFilter()
    {
        initTestForModel(model);

        model.saveContact(filtering_updating_matchingContact);
        waitForContactsChanged();
        var id = model.contacts[0].contactId;

        filterByFirstName.value = "A";
        model.filter = filterByFirstName;
        waitForContactsChanged();

        compare(model.contacts.length, 1, "model is not empty");

        updateContactInJsonDb({contactId: id}, {name: {firstName: "B"}});

        waitForContactsChanged();

        compare(model.contacts.length, 0, "model is empty");
    }

    function initTestCase() {
        cleanupContacts();
    }

    function cleanupTestCase() {
        cleanupContacts();
    }

    function init() {
        initJsonDbAccess();
        createModel();
        waitForModelToBeReady(model);
    }

    function waitForModelToBeReady(model) {
        initTestForModel(model);
        waitForContactsChanged();
    }

    function cleanup() {
        cleanupContacts();
        model.destroy();
    }

    ContactModel {
        id: modelForCleanup
        manager: "jsondb"
        autoUpdate: true
    }

    function cleanupContacts() {
        var modelForCleanup = Qt.createQmlObject(
                    'import QtContacts 5.0;' +
                    'ContactModel {' +
                        'manager: "jsondb";' +
                        'autoUpdate: true;' +
                    '}',
                    contactsJsonDbToModelNotificationE2ETests);
        waitForModelToBeReady(modelForCleanup);

        emptyContacts(modelForCleanup);

        modelForCleanup.destroy();
    }

    function initJsonDbAccess() {
        createSpyForJsonDb();
    }

    JsonDb {
        id: jsonDb

        function createAndSignal(object) {
            console.log("createAndSignal()");
            create(object, resultCallback, errorCallback);
        }

        function removeAndSignal(object) {
            console.log("removeAndSignal()");
            remove(object, resultCallback, errorCallback);
        }

        function updateAndSignal(object) {
            console.log("updateAndSignal()");
            update(object, resultCallback, errorCallback);
        }

        function queryAndSignal(querystr) {
            console.log("queryAndSignal()");
            query(querystr, resultCallback, errorCallback);
        }

        signal operationFinished

        property variant lastResult: {}

        function resultCallback(result) {
            console.log("resultCallback(): result received: " + JSON.stringify(result));
            lastResult = result.data;
            operationFinished();
        }

        function errorCallback(message, code) {
            console.log("errorCallback(): code " + code + ": message: " + message);
        }
    }

    property SignalSpy jsonDbSpy

    function createContactToJsonDb(contact) {
        console.log("createContactToJsonDb()");
        contact["_type"] = "com.nokia.mp.contacts.Contact";
        jsonDb.createAndSignal(contact);
        jsonDbSpy.wait();
    }

    function removeContactFromJsonDb(contact) {
        console.log("removeContactFromJsonDb(): remove contact id " + contact.contactId);

        var query = '[?_type="com.nokia.mp.contacts.Contact"]' +
                '[?_uuid="' + contact.contactId + '"]';
        jsonDb.queryAndSignal(query);
        jsonDbSpy.wait();
        var object = jsonDb.lastResult[0];

        jsonDb.removeAndSignal(object);
        jsonDbSpy.wait();

        jsonDb.queryAndSignal('[?_type="com.nokia.mp.contacts.Contact"]');
        jsonDbSpy.wait();
    }

    // updates only the first name at the moment!
    function updateContactInJsonDb(contact, update) {
        console.log("updateContactInJsonDb(): update contact id " + contact.contactId);

        var query = '[?_type="com.nokia.mp.contacts.Contact"]' +
                '[?_uuid="' + contact.contactId + '"]';
        jsonDb.queryAndSignal(query);
        jsonDbSpy.wait();
        var object = jsonDb.lastResult[0];

        object.name.firstName = update.name.firstName;
        jsonDb.updateAndSignal(object);
        jsonDbSpy.wait();
    }

    function createSpyForJsonDb() {
        console.log("createSpyForJson()");
        jsonDbSpy = Qt.createQmlObject(
                    "import QtTest 1.0;" +
                    "SignalSpy {" +
                    "}",
                    contactsJsonDbToModelNotificationE2ETests);
        jsonDbSpy.target = jsonDb;
        jsonDbSpy.signalName = "operationFinished"
    }

    function compareContactArrays(actual, expected) {
        compare(actual.length, expected.length, "length");
        for (var i = 0; i < expected.length; i++) {
            compareContacts(actual[i], expected[i]);
        }
    }

    function compareContacts(actual, expected) {
        if (expected.name) {
            compare(actual.name.firstName, expected.name.firstName, 'name.firstName');
            compare(actual.name.lastName, expected.name.lastName, 'name.lastName');
        }
        if (expected.email) {
            compare(actual.email.emailAddress, expected.email.emailAddress,
                    'email.emailAddress');
        }
    }
}