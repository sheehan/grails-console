import grails2.app.User

class BootStrap {

    def init = { servletContext ->
        new User(id: 1412, firstName: 'Tybie', lastName: 'McCloughen', email: 'tmccloughen0@t-online.de', city: 'Saint Paul', state: 'MN').save()
        new User(id: 7346, firstName: 'Derward', lastName: 'Menure', email: 'dmenure1@newyorker.com', city: 'Sacramento', state: 'CA').save()
        new User(id: 6383, firstName: 'Rutter', lastName: 'Lehane', email: 'rolehane2@abc.net.au', city: 'Hot Springs National Park', state: 'AR').save()
        new User(id: 4364, firstName: 'Krysta', lastName: 'Wharin', email: 'kwharin3@howstuffworks.com', city: 'Louisville', state: 'KY').save()
        new User(id: 7837, firstName: 'Robbin', lastName: 'Matzke', email: 'rmatzke4@wikispaces.com', city: 'Charleston', state: 'WV').save()
        new User(id: 4738, firstName: 'Wilone', lastName: 'Demange', email: 'wdemange5@github.com', city: 'Boise', state: 'ID').save()
        new User(id: 3748, firstName: 'Clemens', lastName: 'Whitebrook', email: 'cwhitebrook6@miitbeian.gov.cn', city: 'Elmira', state: 'NY').save()
        new User(id: 9565, firstName: 'Michaela', lastName: 'Larter', email: 'mlarter7@multiply.com', city: 'Woburn', state: 'MA').save()
        new User(id: 4737, firstName: 'Madelena', lastName: 'Carleman', email: 'mcarleman8@hatena.ne.jp', city: 'Fort Worth', state: 'TX').save()
        new User(id: 3743, firstName: 'Warden', lastName: 'Chave', email: 'wchave9@va.gov', city: 'Virginia Beach', state: 'VA').save()

    }
    def destroy = {
    }
}
