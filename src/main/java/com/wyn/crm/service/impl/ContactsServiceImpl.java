package com.wyn.crm.service.impl;

import com.wyn.crm.entity.Contacts;
import com.wyn.crm.entity.ContactsRemark;
import com.wyn.crm.mapper.ContactsMapper;
import com.wyn.crm.mapper.ContactsRemarkMapper;
import com.wyn.crm.service.api.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/26
 */
@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;



    public List<Contacts> getContactsForLikeName(String fullname) {
        return contactsMapper.queryContactsForLikeFullname(fullname);
    }

    public List<Contacts> getContactsByConId(String id) {
        List<Contacts> list =  contactsMapper.getContactsByConId(id);
        return list;
    }

    public int saveContacts(Contacts contacts) {
        return contactsMapper.insertSelective(contacts);
    }

    public int deleteContacts(String id) {
        return contactsMapper.deleteByPrimaryKey(id);
    }

    public Contacts getContactsByKeyId(String id) {
        return contactsMapper.getContactsByPrmarKey(id);
    }

    public List<ContactsRemark> getContactsRemark(String id) {
        List<ContactsRemark> remark = contactsRemarkMapper.getContactsRemark(id);
        return remark;
    }

    public int addContactsRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.insertSelective(contactsRemark);
    }

    public int updateRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.updateByPrimaryKeySelective(contactsRemark);
    }

    public int deleteContactsRemark(String id) {
        return contactsRemarkMapper.deleteByPrimaryKey(id);
    }

    public Contacts getContactsRealy(String id) {
        return contactsMapper.selectByPrimaryKey(id);
    }
}
