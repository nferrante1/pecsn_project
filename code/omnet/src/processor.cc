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

#include "processor.h"
#include "transaction_m.h"


namespace pecsn_project {

Define_Module(Processor);

void Processor::initialize()
{
    if(!this->queue->isEmpty()) this->queue->clear();
      this->working = false;
}

void Processor::handleMessage(cMessage *msg)
{
    if(msg->isSelfMessage())
        handleSelfMessage(msg);
    else{
        handleRemoteMessage(msg);
    }
}

void Processor::handleSelfMessage(cMessage *msg)
{
    try {
        Transaction *transaction = check_and_cast<Transaction*>(msg);
        Action action = evaluateAction();
        switch (action) {
        case TERMINATE:
            EV << "Sending response to client";

            transaction->setName("RESPONSE");
            /*respCount++;
             emit(responseSignal, respCount); //Send a signal
             */

            send(transaction, "out", transaction->getGate()); //Respond to client at the correct gate
            break;
        case DISK:
            EV << "Sending transaction to disk" << endl;

            transaction->setName("RESPONSE");
            send(transaction, "out", 0); // 0 is the index of the disk's gate
            break;
        case REMOTE_QUERY:
            EV << "Sending transaction to disk" << endl;

            transaction->setName("RESPONSE");
            send(transaction, "out", 1); // 1 is the index of the remote server's gate
            break;
        default:
            EV << "Unsupported Operation " << endl;
            break;
        }
    } catch (cRuntimeError error) {
        EV << "Error" << error.getFormattedMessage();
    }

    //Get the next queued transaction

    if (!queue->isEmpty()) {
        cMessage * self = check_and_cast<cMessage *>(queue->pop());

        double working_time = exponential(par("serviceTimeMean").doubleValue());

        EV << " - working time: " << working_time;

        scheduleAt(simTime() + working_time, self);
        working = true;
    } else
        working = false;
}

void Processor::handleRemoteMessage(cMessage *msg) {
    EV << "Request arrived";
    try {
        Transaction *transaction = check_and_cast<Transaction*>(msg);

        if (!working) {

            EV << " - working" << endl;
            transaction->setGate(msg->getArrivalGate()->getIndex());
            double working_time = exponential(
                    par("serviceTimeMean").doubleValue());

            EV << " - working time 0: " << working_time << endl;
            scheduleAt(simTime() + working_time, transaction);
            working = true;
        } else {
            EV << " - Added to queue" << endl;
            transaction->setGate(msg->getArrivalGate()->getIndex());
            queue->insert(transaction); //Message added to the queue
        }
    } catch (cRuntimeError error) {
        EV << "Error: "<< error.getFormattedMessage() << endl;
        return;
    }

}

Action Processor::evaluateAction(){
         double random = uniform(0, 1);

         EV << "[evaluateAction] -- Random number generated: " << random;

         double p1 = getParentModule()->par("p1").doubleValue();
         double p2 = getParentModule()->par("p2").doubleValue();
         if(random <= p1)
             return TERMINATE;
         else if(random <= p2)
             return DISK;
         else
             return REMOTE_QUERY;
}
} //namespace
