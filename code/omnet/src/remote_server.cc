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

#include "remote_server.h"
#include "transaction_m.h"

namespace pecsn_project {

Define_Module(Remote_server);

void Remote_server::initialize()
{
    if(!this->queue->isEmpty()) this->queue->clear();
    this->working = false;
}

void Remote_server::handleMessage(cMessage *msg)
{
    if(msg->isSelfMessage())
           handleSelfMessage(msg);
    else
           handleProcessorMessage(msg);

}

void Remote_server::handleProcessorMessage(cMessage* msg)
{
    EV<<"[handleProcessorMessage]: "<< msg->getFullName()<<"working: "<<working<<endl;
    if(working){
       queue->insert(msg);
    }
    else{
        scheduleAt(simTime() + exponential(par("serviceTimeMean").doubleValue()), msg);
        working = true;
    }

}

void Remote_server::handleSelfMessage(cMessage *msg){
            send(msg, "out"); //Send message to processor
            try{
            if(!queue->isEmpty()){

                cMessage * self = check_and_cast<cMessage *>(queue->pop());

                scheduleAt(simTime() + exponential(par("serviceTimeMean").doubleValue()), self);
                working = true;

            }
            else
                working = false;
            } catch (cRuntimeError *error){
                               EV<<error->getFormattedMessage()<<endl;
                           }
}

void Remote_server::~Remote_server(){
    delete queue;
    working = false;
}

} //namespace
