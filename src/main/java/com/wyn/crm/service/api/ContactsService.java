package com.wyn.crm.service.api;

import com.wyn.crm.entity.Contacts;
import com.wyn.crm.entity.ContactsRemark;
import com.wyn.crm.mapper.ContactsMapper;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/26
 */
public interface ContactsService {

    /**
     * 通过模糊查询来查找联系人
     * @param fullname
     * @return
     */
   List<Contacts> getContactsForLikeName(String fullname);

    List<Contacts> getContactsByConId(String id);

    int saveContacts(Contacts contacts);

    int deleteContacts(String id);

    Contacts getContactsByKeyId(String id);


    List<ContactsRemark> getContactsRemark(String id);


    int addContactsRemark(ContactsRemark contactsRemark);

    int updateRemark(ContactsRemark contactsRemark);

    int deleteContactsRemark(String id);

    Contacts getContactsRealy(String id);
}
