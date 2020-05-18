//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

#include "client.h"
#include "transaction_m.h"
namespace pecsn_project {

Define_Module(Client);

Client::~Client(){

}

void Client::initialize()
{
    responseTime = registerSignal("responseTime");
    EV<<"Sending transaction"<<endl;
    start = simTime();
    Transaction *transaction = new Transaction("REQUEST");
    send(transaction, "out");

}

void Client::handleMessage(cMessage *msg)
{
    cancelAndDelete(msg);

    emit(responseTime, simTime() - start);

    EV<<"Response arrived"<<endl;
    //A response from the server arrives, so a new request is issued
    Transaction *transaction = new Transaction("REQUEST");
    send(transaction, "out");
    start = simTime();
}

} //namespace
